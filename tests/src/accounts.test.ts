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

    test('account trigger correct', async () => {
        const {data, error} = await supabase
            .from('accounts')
            .select('*, account_users!inner(*)')
            .eq('account_users.user_id', user.id)
            .single()

        expect(error).toBeNull()
        expect(data).not.toBeNull()
        expect(data.name).toBe(email)
    })

    
})