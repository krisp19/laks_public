***WARNING***
#  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

This docker container streams market data realtime from IG using lightstreamer. As an example, FTSE100 index tick is streamed realtime.

Pre-Requisites:
- You have an account with IG which is real or Demo. To setup these or for more information please visit https://labs.ig.com/sample-apps/api-companion/index.html
- You have created a corresponding username and password.
- You have created an API key that is active.
- You have good knowledge of python.
- You have good knowledge of docker.

To build from source:
- Clone this repo and navigate to ig/market/data directory.
- Perform a docker build (Eg: docker build --rm -t "ig_market_data" .) . Notice the .(dot) in the end is intentional
- Run the container by setting the enviornment variables
  Eg: docker run --name market_data -e ig_account_id="your_account_id_obtained_from_ig" -e ig_account_type="Demo/Real" -e ig_password="your_account_password" -e ig_user_name="your_user_name" -e ig_api_key="your_api_key" -dit ig_market_data
  
  account_id in ig is usually a 5 char random string as seen in your IG web portal: Eg: ABCDE. 
  account_type is the type of account which is demo or real. Eg:  Demo/Real
  ig_password: The password of the account. Note this password may be different from your main account password. Its usually the password you set for apps like these. Eg: ig_password="password_set_for_this_app"
  ig_user_name: The user_name of the account. Note this user_name may be different from your main account password. Its usually the user_name you set for apps like these. ig_user_name="user_name_set_for_this_app"
  ig_api_key: The api key for this application. ig_api_key="long_api_key_shown_in_your_ig_portal"

Set the above parameters and run the docker container. The output would appear as under:

![image](https://user-images.githubusercontent.com/55232057/85843036-81464700-b798-11ea-9e0e-f5834b9f1452.png)

You can now host this container in ECS/EKS in AWS or ACS/AKS in Azure accounts.
