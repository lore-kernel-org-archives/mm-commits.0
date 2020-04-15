From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [External] Re: +
 mm-ksm-fix-null-pointer-dereference-when-ksm-zero-page-is-enabled.patch
 added to -mm tree
Date: Wed, 15 Apr 2020 11:32:48 -0700
Message-ID: <20200415113248.1c17147d0991099d358b4bef@linux-foundation.org>
References: <20200415015410.glIzXqR5d%akpm@linux-foundation.org>
        <49e65ca7-03a2-9a82-9e1a-cf997320bcfd@virtuozzo.com>
        <CAMZfGtWwE_9uSH9Vw+W2yJJhMo4BfWHx_PME+HD5h3r+A3zXeg@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1416781AbgDOScw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Apr 2020 14:32:52 -0400
In-Reply-To: <CAMZfGtWwE_9uSH9Vw+W2yJJhMo4BfWHx_PME+HD5h3r+A3zXeg@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Muchun Song <songmuchun@bytedance.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, david@redhat.com, Xiongchun duan <duanxiongchun@bytedance.com>, hughd@google.com, imbrenda@linux.vnet.ibm.com, Markus Elfring <Markus.Elfring@web.de>, mm-commits@vger.kernel.org, stable@vger.kernel.org, yang.shi@linux.alibaba.com

On Wed, 15 Apr 2020 16:16:50 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> > In case of vma is out of date, we also may consider to exit this function without
> > calling unstable_tree_search_insert().
> 
> Yeah, I agree with you. Should I send another patch to fix this patch
> or an upgraded
> version(v4) of this patch.

Either is OK.
