# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Errorio.Repo.insert!(%Errorio.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

require Logger
alias Errorio.Repo

user = Repo.insert!(%Errorio.User{name: "Admin", email: "dev@fodojo.com", is_admin: true});

pswrd = :crypto.strong_rand_bytes(12) |> Base.url_encode64 |> binary_part(0, 12)

Repo.insert!(%Errorio.Authorization{
                                      provider: "identity",
                                      uid: "dev@fodojo.com",
                                      user_id: 1,
                                      token: Comeonin.Bcrypt.hashpwsalt(pswrd)
                                    }
            );

Logger.info user.email
Logger.info pswrd
