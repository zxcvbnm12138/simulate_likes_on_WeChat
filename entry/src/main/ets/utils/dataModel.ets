import { upload_local } from './tool';
import { cloudDatabase } from '@kit.CloudFoundationKit';

let databaseZone = cloudDatabase.zone('QuickStartDemo');

export interface comment_obj {
  comment_avatar: string
  comment_nickname: string
  comment_content: string
  comment_time: number
}

export interface personal_data {
  wx_number: string;
  data: personal_detail_data
}

export interface personal_detail_data {
  avatar: string;
  nickname: string
  district: string;
  pyq_first4_pic: string[]
  pyq_data: personal_every_year_pyq_data[]
  bg?: string;
}

export interface personal_every_year_pyq_data {
  year: number;
  pyq_data_list: pyq_data[]
}

export interface pyq_data {
  content: string;
  gallery: string[];
  location: string;
  love_num: number;
  comment_num: number;
  comment_content?: comment_obj[]
  show_time: string;
  share_time: number;
  link?: string;
  link_image_url?: string;
  share_source?: string
}


export function convertTime(timestamp: number) {
  // 获取当前的时间戳
  const currentTimestamp = new Date().getTime();
  const timeDifference = (currentTimestamp - timestamp) / 1000; // 转换为秒

  if (timeDifference < 5 || timeDifference == 0) {
    return "刚刚";
  } else if (timeDifference < 60) {
    return `${Math.floor(timeDifference)}秒前`;
  } else if (timeDifference < 3600) {
    return `${Math.floor(timeDifference / 60)}分钟前`;
  } else if (timeDifference < 86400) {
    return `${Math.floor(timeDifference / 3600)}小时前`;
  } else if (timeDifference < 604800) {
    return `${Math.floor(timeDifference / 86400)}天前`;
  } else if (timeDifference < 2592000) {
    return `${Math.floor(timeDifference / 604800)}周前`;
  } else if (timeDifference < 31536000) {
    return `${Math.floor(timeDifference / 2592000)}个月前`;
  } else {
    return `${Math.floor(timeDifference / 31536000)}年前`;
  }
}

export function fake_data(context: Context | undefined) {
  let pyq_first4_pic_list: string[] = []
  let personal_every_year_pyq_data_list: personal_every_year_pyq_data[] = []
  let avater_url: string = 'test_avater.jpg'
  let bg: string = 'pyq_bg.jpg'

  const person_avater = upload_local(avater_url, context)
  const person_pyq_bg = upload_local(bg, context)


  let pyq_data2024: pyq_data[] = [
    {
      content: '#2024🔚\n\n忙碌又充实的一年，喜乐与感恩的一年\n感恩遇到的人，经历的事，学到的所有和受到的支持。现在回想年初的目标也在祂的带领下不知不觉的完成了\n\n谢谢今年出现在我身边的一切，因为你们我现在仍然是个开朗的小女孩🥰',
      gallery: [person_avater,
        person_avater,
        person_avater,
        person_avater,
        person_avater,
        person_avater],
      location: '惠州市·惠州奥林匹克体育场',
      love_num: 38,
      comment_num: 4,
      comment_content: [
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2024-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2024-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2024-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2024-10-29').getTime()
        }
      ],
      show_time: convertTime(new Date('2024-10-29').getTime()),
      share_time: new Date('2024-10-29').getTime(),
      share_source: '酷狗概念版'
    },
    {
      content: '感恩遇到的人，经历的事，学到的所有和受到的支持。现在回想年初的目标也在祂的带领下不知不觉的完成了\n\n谢谢今年出现在我身边的一切，因为你们我现在仍然是个开朗的小女孩🥰',
      gallery: [person_avater,
        person_avater],
      location: '江门市·五邑大学',
      love_num: 55,
      comment_num: 4,
      comment_content: [
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2024-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2024-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2024-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2024-10-29').getTime()
        }
      ],
      show_time: convertTime(new Date('2024-12-10').getTime()),
      share_time: new Date('2024-12-10').getTime(),
    },
  ]
  let pyq_data2023: pyq_data[] = [
    {
      content: '#2023🔚\n\n忙碌又充实的一年，喜乐与感恩的一年\n感恩遇到的人，经历的事，学到的所有和受到的支持。现在回想年初的目标也在祂的带领下不知不觉的完成了\n\n谢谢今年出现在我身边的一切，因为你们我现在仍然是个开朗的小女孩🥰',
      gallery: [person_avater,
        person_avater,
        person_avater,
        person_avater,
        person_avater,
        person_avater],
      location: '惠州市·惠州奥林匹克体育场',
      love_num: 25,
      comment_num: 4,
      comment_content: [
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2023-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2023-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2023-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2023-10-29').getTime()
        }
      ],
      show_time: convertTime(new Date('2023-8-29').getTime()),
      share_time: new Date('2023-8-29').getTime(),
    },
    {
      content: '感恩遇到的人，经历的事，学到的所有和受到的支持。现在回想年初的目标也在祂的带领下不知不觉的完成了\n\n谢谢今年出现在我身边的一切，因为你们我现在仍然是个开朗的小女孩🥰',
      gallery: [],
      location: '江门市·五邑大学',
      love_num: 2,
      comment_num: 4,
      comment_content: [
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2023-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2023-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2023-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2023-10-29').getTime()
        }
      ],
      show_time: convertTime(new Date('2023-11-9').getTime()),
      share_time: new Date('2023-11-9').getTime(),
    },
  ]
  let pyq_data2022: pyq_data[] = [
    {
      content: '#2022🔚\n\n忙碌又充实的一年，喜乐与感恩的一年\n感恩遇到的人，经历的事，学到的所有和受到的支持。现在回想年初的目标也在祂的带领下不知不觉的完成了\n\n谢谢今年出现在我身边的一切，因为你们我现在仍然是个开朗的小女孩🥰',
      gallery: [person_avater,
        person_avater,
        person_avater,
        person_avater,
        person_avater,
        person_avater,
        person_avater,
        person_avater,
        person_avater],
      location: '惠州市·惠州奥林匹克体育场',
      love_num: 10,
      comment_num: 9,
      comment_content: [
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        }
      ],
      show_time: convertTime(new Date('2022-4-29').getTime()),
      share_time: new Date('2022-4-29').getTime(),
    },
    {
      content: '感恩遇到的人，经历的事，学到的所有和受到的支持。现在回想年初的目标也在祂的带领下不知不觉的完成了\n\n谢谢今年出现在我身边的一切，因为你们我现在仍然是个开朗的小女孩🥰',
      gallery: [person_avater,
        person_avater],
      location: '江门市·五邑大学',
      love_num: 40,
      comment_num: 7,
      comment_content: [
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        },
        {
          comment_avatar: person_avater,
          comment_nickname: '菠萝吹雪',
          comment_content: '真不错啊',
          comment_time: new Date('2022-10-29').getTime()
        }
      ],
      show_time: convertTime(new Date('2022-5-9').getTime()),
      share_time: new Date('2022-5-9').getTime(),
    }
  ]

  let pyq_data_list: pyq_data[][] = [pyq_data2023, pyq_data2024, pyq_data2022]


  for (let m: number = 0; m < pyq_data_list.length; m++) {

    let data_list: pyq_data[] = [];

    for (let n: number = 0; n < pyq_data_list[m].length; n++) {

      data_list.push(pyq_data_list[m][n])

      if (pyq_data_list[m][n].gallery!.length > 0) {
        pyq_first4_pic_list.push(...pyq_data_list[m][n].gallery)
      }
    }
    let personal_every_year_pyq_data: personal_every_year_pyq_data = {
      year: new Date(pyq_data_list[m][0].share_time).getFullYear(),
      pyq_data_list: data_list
    }
    personal_every_year_pyq_data_list.push(personal_every_year_pyq_data)

  }

  let personal_detail_data: personal_detail_data = {
    avatar: person_avater,
    nickname: '菠萝吹雪',
    district: '广东 惠州',
    pyq_first4_pic: pyq_first4_pic_list,
    pyq_data: personal_every_year_pyq_data_list,
    bg: person_pyq_bg
  }

  let personal_data: personal_data = {
    wx_number: 'cay2015999',
    data: personal_detail_data
  }

  let personal_data_list: personal_data[] = []
  personal_data_list.push(personal_data)

  return personal_data_list
}


export function fake_all_data(context: Context | undefined) {
  let avater_url: string = 'hejtea14rimy.jpg'
  let pyq_first4_pic_list: string[] = ['hejtea14rimy_pyq1.jpg', 'hejtea14rimy_pyq2.jpg',
    'hejtea14rimy_pyq3.jpg', 'hejtea14rimy_pyq4.jpg']
  let new_pyq_first4_pic_list: string[] = []


  const person_avater = upload_local(avater_url, context)

  for (let index = 0; index < pyq_first4_pic_list.length; index++) {
    const element = upload_local(pyq_first4_pic_list[index], context);
    new_pyq_first4_pic_list.push(element)
  }
  let gallery_list: string[] = [new_pyq_first4_pic_list[0], new_pyq_first4_pic_list[1]]


  let friends_data: personal_data = {
    wx_number: 'hejtea14rimy',
    data: {
      avatar: person_avater,
      nickname: '考拉例外',
      district: '冰岛',
      pyq_first4_pic: new_pyq_first4_pic_list,
      pyq_data: [{
        year: 2025,
        pyq_data_list: [{
          content: '桥上有只猫',
          gallery: gallery_list,
          location: '',
          love_num: 0,
          comment_num: 1,
          comment_content: [
            {
              comment_avatar: person_avater,
              comment_nickname: '菠萝吹雪',
              comment_content: '真不错啊',
              comment_time: new Date('2024-10-29').getTime()
            }
          ],
          show_time: convertTime(new Date('2025-1-8 18:47').getTime()),
          share_time: new Date('2025-1-8 18:47').getTime(),
        }]
      }]
    }
  }

  return friends_data
}

@Preview
@Component
struct dddd {
  aboutToAppear(): void {
  }

  build() {
  }
}

