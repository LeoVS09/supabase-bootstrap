import { User } from "@supabase/supabase-js"
import { supabase } from "./supabase-client"


describe('accounts', () => {

    const username = `test_${Math.random().toString().slice(2)}`
    const email = `${username}@test.com`
    let user: User

    beforeAll(async () => {
        const {data, error} = await supabase.auth.api.createUser({
            email
        })

        if (error) {
            throw error
        }

        user = data!
    })

    test('retrive user', async () => {
        const {data, error} = await supabase.auth.api.listUsers()

        expect(error).toBeNull()
        expect(data).not.toBeNull()
        expect(data?.filter(user => user.email == email).length !== 0).toBe(true)
    })

    test('trigger correct', async () => {
        const {data, error} = await supabase
            .from('accounts')
            .select('*, account_users!inner(*)')
            .eq('account_users.user_id', user.id)
            .single()

        expect(error).toBeNull()
        expect(data).not.toBeNull()
        expect(data.name).toBe(email)
    })

    test('create user with existing account', async () => {
        const account = await supabase
            .from('accounts')
            .select('*, account_users!inner(*)')
            .eq('account_users.user_id', user.id)
            .single()

        if (account.error)
            throw account.error

        const secondUserEmail = `${username}@second.com`

        const secondUser = await supabase.auth.api.createUser({
            email: secondUserEmail,
            // @ts-ignore
            user_metadata: {
                account_id: account.data.id,
            }
        })

        if (secondUser.error)
            throw secondUser.error

        const {data, error} = await supabase
            .from('accounts')
            .select('*, account_users!inner(*)')
            .eq('account_users.user_id', secondUser.data.id)
            .single()

        expect(error).toBeNull()
        expect(data).not.toBeNull()
        expect(data.id).toBe(account.data.id)
    })

    
})

