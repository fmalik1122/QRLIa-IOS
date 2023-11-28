// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RetrofitGenerator
// ************flutter pub run build_runner build**************************************************************

class _ApiClient implements ApiClient {

  final Dio _dio;
  String? baseUrl;

  _ApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'http://qrlia.com/api/';
  }

  @override
  Future<Register> RegisterAPI(key, username, phone, countrycode, password,  isiostoken , fToken) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'username': username, 'phone': phone, 'countrycode': countrycode, 'password': password, 'isiostoken' : isiostoken , 'firebasetoken': fToken};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectSignUp',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = Register.fromJson(_result.data);
    return value;
  }

  @override
  Future<Register> LoginAPI(key, email, password, isiostoken, fToken) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'email': email, 'password': password, 'isiostoken' : isiostoken, 'firebasetoken': fToken};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectLogin',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = Register.fromJson(_result.data);
    return value;
  }

  @override
  Future<Profile> ProfileApi(key, userid) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': userid};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectGetProfile',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = Profile.fromJson(_result.data);
    return value;
  }

  @override
  Future<Register> DeleteApi(key, userid) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': userid};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectDeleteAccount',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = Register.fromJson(_result.data);
    return value;
  }

  @override
  Future<ProfileUpdate> UpdateProfileAPI(key, id, usersname, qrtitle, userimage, accounttype,businessaddress,cusaddress,businesslongitude, businesslatitude, businesstype, workbusinessname, worktitle, workemail, website, phone, CountryCode, isvirtualbusiness, email, about) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id, 'usersname': usersname, 'userimage': userimage, 'qrtitle' : qrtitle , 'accounttype': accounttype, 'businessaddress': businessaddress, 'cusaddress' : cusaddress, 'businesslongitude': businesslongitude, 'businesslatitude': businesslatitude, 'businesstype': businesstype, 'workbusinessname': workbusinessname, 'worktitle': worktitle, 'workemail': workemail, 'website': website ,'phone': phone, 'CountryCode' : CountryCode,'isvirtualbusiness': isvirtualbusiness, 'email': email, 'about' : about};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectUpdateProfile',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = ProfileUpdate.fromJson(_result.data);
    return value;
  }

  @override
  Future<Friends> FriendsList(key, id) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectGetFriendsList',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = Friends.fromJson(_result.data);
    return value;
  }

  @override
  Future<FriendProfile> GetFriendProfileAPI(key,id, fid) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id, 'frienduserid' : fid};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectGetFriendProfile',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = FriendProfile.fromJson(_result.data);
    return value;
  }

  @override
  Future<Register> YesYesConnectPassUpdateAPI(key, id, password, email) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id, 'newpassword': password, 'email': email};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectUpdatePassword',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = Register.fromJson(_result.data);
    return value;
  }

  @override
  Future<FriendQrModel> FriendQr(key,id, friendid, meetingtime) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id , 'frienduserid': friendid, 'meetingtime' : meetingtime};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectMakeFriend',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = FriendQrModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<FriendQrModel> SetQrTitle(key,id, qrtitle) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id , 'qrtitle': qrtitle};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectUpdateQRtitle',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = FriendQrModel.fromJson(_result.data);
    return value;
  }


  @override
  Future<SettingsData> GetSettingsRequest(key,id) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectGetSettings',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = SettingsData.fromJson(_result.data);
    return value;
  }

  @override
  Future<SettingsData> UpdateSettingsRequest(key,newemail,webprofileshow,profilepicshow,sociallinksshow,locationshow,phonenumbershow, businessemail, companyname,worktitle,profileshare,id) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key,'email': newemail, 'webprofileshow': webprofileshow, 'profilepicshow': profilepicshow, 'sociallinksshow': sociallinksshow, 'locationshow': locationshow, 'phonenumbershow': phonenumbershow, 'businessemail': businessemail, 'companyname': companyname, 'worktitle': worktitle, 'allowprofilesharing': profileshare, 'userid': id};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectUpdateSettings',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = SettingsData.fromJson(_result.data);
    return value;
  }

  @override
  Future<NotificationsModel> NotificationsAPI(key, id) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectGetNotifications',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = NotificationsModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<Register> AddSelfie(key, id, selfie) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'connectionid': id, 'connectselfie': selfie};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectAddSelfie',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = Register.fromJson(_result.data);
    return value;
  }

  @override
  Future<Register> AddComment(key, id, comment) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'connectionid': id, 'connectcomment': comment};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectAddComment',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = Register.fromJson(_result.data);
    return value;
  }

  @override
  Future<ShareModel> ShareProfile(key,id, friendBid, friendCid, msg) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id , 'friendBuserid': friendBid, 'friendCuserid': friendCid, 'message': msg };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectSendShareRequest',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = ShareModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<UserNetworksListModel> UserNetworkList(key,id) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectGetUsersNetworksList',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = UserNetworksListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<UserNetworksListModel> AllNetworkList(key,id) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectGetNetworksList',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = UserNetworksListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<Register> UpdateUserNetworkListAPI(key, network) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'Data': network};
    _data.removeWhere((k, v) => v == null);
    final result = await _dio.post(
        baseUrl! + 'YesYesConnectUpdateUsersNetworksList',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra));
    final value = Register.fromJson(result.data);
    return value;
  }

  @override
  Future<Register> CheckHandle(key, username) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'username': username};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectHandleCheck',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = Register.fromJson(_result.data);
    return value;
  }

  @override
  Future<Register> AddLocationAPI(key, id, adrees, lat, long) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'connectionid': id , 'connectaddress': adrees , 'connectlongitude': long , 'connectlatitude': lat};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectAddLocation',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = Register.fromJson(_result.data);
    return value;
  }

  @override
  Future<Register> BlockUser(key, id, connectionid, frienduserid ) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id, 'connectionid': connectionid, 'frienduserid' : frienduserid};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectBlock',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = Register.fromJson(_result.data);
    return value;
  }

  @override
  Future<Register> UnBlockUser(key, id, connectionid, frienduserid ) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id, 'connectionid': connectionid, 'frienduserid' : frienduserid};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectUnblock',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = Register.fromJson(_result.data);
    return value;
  }

  @override
  Future<Register> CheckUser(key, userid) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': userid};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectUserCheck',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = Register.fromJson(_result.data);
    return value;
  }

  @override
  Future<BusinessPageModel> GetBusinessPageAPI(key,id) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectGetBusinessPage',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = BusinessPageModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<BusinessPageModel> BusinessPageUpdateAPI(key, id, BusinessPageName,BusinessPageLogo,BusinessPageWebsite,BusinessPageType,BusinessPageDescription) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id, 'BusinessPageName': BusinessPageName, 'BusinessPageLogo' : BusinessPageLogo,'BusinessPageWebsite': BusinessPageWebsite, 'BusinessPageType': BusinessPageType, 'BusinessPageDescription': BusinessPageDescription};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectBusinessPageUpdate',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = BusinessPageModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<CategoriesListModel> GetCateListAPI(key,userid) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': userid};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectGetMyCategoriesList',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = CategoriesListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<CategoriesListModel> AddCateAPI(key,id, CategoryName) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id, 'CategoryName' : CategoryName};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectAddCategory',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = CategoriesListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<CategoriesListModel> UpdateCateAPI(key,id,CategoryId,  CategoryName) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id, 'CategoryId' : CategoryId, 'CategoryName' : CategoryName};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectUpdateCategory',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = CategoriesListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<CategoriesListModel> DeleteCateAPI(key,id, CategoryName) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id, 'CategoryName' : CategoryName};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectAddCategory',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = CategoriesListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<ProductServiceListDataModel> GetProdListAPI(key,owneruserid) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'owneruserid': owneruserid};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectGetProductsList',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = ProductServiceListDataModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<GroupListModel> GetGroupListAPI(key,owneruserid) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'owneruserid': owneruserid};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectGetGroupList',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = GroupListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<GroupListModel> AddGroupAPI(key,owneruserid, memberuserid) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'owneruserid': owneruserid, 'memberuserid' : memberuserid};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectAddToGroup',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = GroupListModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<BusinessPageModel> AddProductServiceAPI(key, id, Type,Name,Description,Price,CategoryId,FileType,Image,File) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id, 'Type': Type, 'Name' : Name,'Description': Description, 'Price': Price, 'CategoryId': CategoryId, 'FileType': FileType, 'Image' : Image, 'File' : File};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectAddProduct',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = BusinessPageModel.fromJson(_result.data);
    return value;
  }

  @override
  Future<BusinessPageModel> UpdateProductServiceAPI(key, id, ProductId ,Type,Name,Description,Price,CategoryId,FileType,Image,File) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id, 'ProductId' : ProductId , 'Type': Type, 'Name' : Name,'Description': Description, 'Price': Price, 'CategoryId': CategoryId, 'FileType': FileType, 'Image' : Image, 'File' : File};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectUpdateProduct',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = BusinessPageModel.fromJson(_result.data);
    return value;
  }


  @override
  Future<BusinessPageModel> DeleteProductServiceAPI(key,id, ProductId) async {
    ArgumentError.checkNotNull(key, 'api_key');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'api_key': key, 'userid': id, 'ProductId' : ProductId};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.post(
        baseUrl! + 'YesYesConnectDeleteProduct',
        data: _data,
        queryParameters: queryParameters,
        options: Options(
          method: 'POST',
          headers: <String, dynamic>{},
          extra: _extra,
        ));
    final value = BusinessPageModel.fromJson(_result.data);
    return value;
  }

}