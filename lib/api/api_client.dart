import 'package:barcodeprinter/DataModers/GroupListModel.dart';
import 'package:barcodeprinter/DataModers/ProfileUpdate.dart';
import 'package:barcodeprinter/DataModers/Register.dart';
import 'package:barcodeprinter/DataModers/ShareModel.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../DataModers/BusinessPageModel.dart';
import '../DataModers/CategoriesListModel.dart';
import '../DataModers/FrieList.dart';
import '../DataModers/FriendQrModel.dart';
import '../DataModers/FriendsProfile.dart';
import '../DataModers/NotificationsModel.dart';
import '../DataModers/ProductServiceListDataModel.dart';
import '../DataModers/SettingsData.dart';
import '../DataModers/UserNetworkListModel.dart';
import '../DataModers/profile.dart';

part 'api_client.g.dart';

abstract class ApiClient {

  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  Future<Register> RegisterAPI(
      @Field("api_key") String key,
      @Field("username") String username,
      @Field("phone") String phone,
      @Field("countrycode") String countrycode,
      @Field("password") String password,
      @Field("isiostoken") String isiostoken,
      @Field("firebasetoken") String fToken);

  Future<Register> LoginAPI(
      @Field("api_key") String key,
      @Field("email") String email,
      @Field("password") String password,
      @Field("isiostoken") String isiostoken,
      @Field("firebasetoken") String fToken);

  Future<Profile> ProfileApi(
      @Field("api_key") String key,
      @Field("userid") String userid);

  Future<Register> DeleteApi(
      @Field("api_key") String key,
      @Field("userid") String userid);

  Future<ProfileUpdate> UpdateProfileAPI(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("usersname") String usersname,
      @Field("qrtitle") String qrtitle,
      @Field("userimage") String userimage,
      @Field("accounttype") String accounttype,
      @Field("businessaddress") String businessaddress,
      @Field("cusaddress") String cusaddress,
      @Field("businesslongitude") String businesslongitude,
      @Field("businesslatitude") String businesslatitude,
      @Field("businesstype") String businesstype,
      @Field("workbusinessname") String workbusinessname,
      @Field("worktitle") String worktitle,
      @Field("workemail") String workemail,
      @Field("website") String website,
      @Field("phone") String phone,
      @Field("CountryCode") String CountryCode,
      @Field("isvirtualbusiness") String isvirtualbusiness,
      @Field("email") String email,
      @Field("about") String about);

  Future<Friends> FriendsList(
      @Field("api_key") String key,
      @Field("userid") String id);

  Future<Register> YesYesConnectPassUpdateAPI(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("newpassword") String newpassword,
      @Field("email") String email);

  Future<FriendQrModel>  SetQrTitle(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("qrtitle") String qrtitle);

  Future<FriendQrModel> FriendQr(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("frienduserid") String frienduserid,
      @Field("meetingtime") String meetingtime);

  Future<FriendProfile>  GetFriendProfileAPI(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("frienduserid") String frienduserid);

  Future<SettingsData> GetSettingsRequest(
      @Field("api_key") String key,
      @Field("userid") String id);

  Future<SettingsData> UpdateSettingsRequest(
      @Field("api_key") String key,
      @Field("email") String newemail,
      @Field("webprofileshow") String webprofileshow,
      @Field("profilepicshow") String profilepicshow,
      @Field("sociallinksshow") String sociallinksshow,
      @Field("locationshow") String locationshow,
      @Field("phonenumbershow") String phonenumbershow,
      @Field("businessemail") String businessemail,
      @Field("companyname") String companyname,
      @Field("worktitle") String worktitle,
      @Field("allowprofilesharing") String profileshare,
      @Field("userid") String id);

  Future<NotificationsModel> NotificationsAPI(
      @Field("api_key") String key,
      @Field("userid") String id);

  Future<Register> AddSelfie(
      @Field("api_key") String key,
      @Field("connectionid") String connectionid,
      @Field("connectselfie") String connectselfie);

  Future<Register> AddComment(
      @Field("api_key") String key,
      @Field("connectionid") String connectionid,
      @Field("connectcomment") String connectcomment);

  Future<ShareModel> ShareProfile(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("friendBuserid") String friendBuserid,
      @Field("friendCuserid") String friendCuserid,
      @Field("message") String message);

  Future<UserNetworksListModel> UserNetworkList(
      @Field("api_key") String key,
      @Field("userid") String id);

  Future<Register> UpdateUserNetworkListAPI(
      @Field("api_key") String key,
      @Body() UserNetworksListModel network);

  Future<UserNetworksListModel> AllNetworkList(
      @Field("api_key") String key,
      @Field("userid") String id);

  Future<Register> CheckHandle(
      @Field("api_key") String key,
      @Field("username") String username);

  Future<Register> CheckUser(
      @Field("api_key") String key,
      @Field("userid") String userid);

  Future<Register> AddLocationAPI(
      @Field("api_key") String key,
      @Field("connectionid") String connectionid,
      @Field("connectaddress") String connectaddress,
      @Field("connectlongitude") String connectlongitude,
      @Field("connectlatitude") String connectlatitude);

  Future<Register> BlockUser(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("connectionid") String connectionid,
      @Field("frienduserid") String frienduserid);

  Future<Register> UnBlockUser(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("connectionid") String connectionid,
      @Field("frienduserid") String frienduserid);

  Future<BusinessPageModel>  GetBusinessPageAPI(
      @Field("api_key") String key,
      @Field("userid") String id);

  Future<BusinessPageModel> BusinessPageUpdateAPI(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("BusinessPageName") String BusinessPageName,
      @Field("BusinessPageLogo") String BusinessPageLogo,
      @Field("BusinessPageWebsite") String BusinessPageWebsite,
      @Field("BusinessPageType") String BusinessPageType,
      @Field("BusinessPageDescription") String BusinessPageDescription);

  Future<CategoriesListModel> GetCateListAPI(
      @Field("api_key") String key,
      @Field("userid") String userid);

  Future<CategoriesListModel> AddCateAPI(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("CategoryName") String CategoryName);

  Future<CategoriesListModel> UpdateCateAPI(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("CategoryId") String CategoryId,
      @Field("CategoryName") String CategoryName);

  Future<CategoriesListModel> DeleteCateAPI(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("CategoryName") String CategoryName);

  Future<ProductServiceListDataModel> GetProdListAPI(
      @Field("api_key") String key,
      @Field("owneruserid") String owneruserid);

  Future<GroupListModel> GetGroupListAPI(
      @Field("api_key") String key,
      @Field("owneruserid") String owneruserid);

  Future<GroupListModel> AddGroupAPI(
      @Field("api_key") String key,
      @Field("owneruserid") String owneruserid,
      @Field("memberuserid") String memberuserid);

  Future<BusinessPageModel> AddProductServiceAPI(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("Type") String Type,
      @Field("Name") String Name,
      @Field("Description") String Description,
      @Field("Price") String Price,
      @Field("CategoryId") String CategoryId,
      @Field("FileType ") String FileType,
      @Field("Image") String Image,
      @Field("File") String File);

  Future<BusinessPageModel> UpdateProductServiceAPI(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("ProductId") String ProductId,
      @Field("Type") String Type,
      @Field("Name") String Name,
      @Field("Description") String Description,
      @Field("Price") String Price,
      @Field("CategoryId") String CategoryId,
      @Field("FileType ") String FileType,
      @Field("Image") String Image,
      @Field("File") String File);

  Future<BusinessPageModel> DeleteProductServiceAPI(
      @Field("api_key") String key,
      @Field("userid") String id,
      @Field("ProductId") String ProductId);

}