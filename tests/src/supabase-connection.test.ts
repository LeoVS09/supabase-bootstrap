import {
    createClient,
} from "@supabase/supabase-js";

describe('client', () => {
    const supabase = createClient(
        process.env.SUPABASE_URL!,
        process.env.SUPABASE_KEY!,
      );

    test('retrive users', async () => {
        const {data, error} = await supabase.auth.api.listUsers()

        expect(error).toBeNull()
        expect(data).not.toBeNull()
    })

    
})