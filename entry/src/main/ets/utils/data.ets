import { cloudDatabase } from '@kit.CloudFoundationKit';

// 评论对象（comment_obj）
class comment_obj extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return "comment_obj";
  }
  // 非主键/非必填字段，允许 undefined
  public comment_avatar: string | undefined;
  public comment_nickname: string | undefined;
  public comment_content: string | undefined;
  public comment_time: string | undefined;
  // 主键/必填字段，不允许 undefined
  public wx_number: string | undefined;
  public pyq_id: string | undefined;
}

// 朋友圈数据（pyq_data）
class pyq_data extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return "pyq_data";
  }
  // 主键/必填字段
  public wx_number: string | undefined;
  // 非主键/非必填字段
  public year: number | undefined;
  public content: string | undefined;
  public gallery: string | undefined;
  public location: string | undefined;
  public love_num: number | undefined;
  public comment_num: number | undefined;
  public comment_content: string | undefined;
  public show_time: string | undefined;
  public share_time: string | undefined;
  public link: string | undefined;
  public link_image_url: string | undefined;
  public share_source: string | undefined;
  // 非主键/必填字段
  public pyq_id: string | undefined;
}

// 个人详情数据（personal_detail_data）
class personal_detail_data extends cloudDatabase.DatabaseObject {
  public naturalbase_ClassName(): string {
    return "personal_detail_data";
  }
  // 主键/必填字段
  public wx_number: string | undefined;
  // 非主键/非必填字段
  public avatar: string | undefined;
  public nickname: string | undefined;
  public district: string | undefined;
  public pyq_first4_pic: string | undefined;
  public bg: string | undefined;
}

export { comment_obj, pyq_data, personal_detail_data };