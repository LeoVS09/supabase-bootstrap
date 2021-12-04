import { User } from "@supabase/supabase-js"
import { supabase} from "./supabase-client"


describe('profiles', () => {

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
        const users = await supabase.auth.api.listUsers()
        
        const {data, error} = await supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single()

        expect(error).toBeNull()
        expect(data).not.toBeNull()
        expect(data.username).toBe(email)
    })

    
})