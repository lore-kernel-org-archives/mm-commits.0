From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2016-08-02-15-53 uploaded
Date: Tue, 10 Oct 2017 12:37:49 -0700
Message-ID: <20171010123749.2c59f3b762b3c0b33e80a67d__11462.0549059056$1507664285$gmane$org@linux-foundation.org>
References: <57a124aa.eJmVCvd1SOHlQ1X8%akpm@linux-foundation.org>
        <CAGF4SLgi6jgtxbqtTEjL8FGXUHHsSm6KeoVqANLt3LB6OTBboA@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38828 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751704AbdJJThw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 15:37:52 -0400
In-Reply-To: <CAGF4SLgi6jgtxbqtTEjL8FGXUHHsSm6KeoVqANLt3LB6OTBboA@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vitaly Mayatskih <v.mayatskih@gmail.com>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz, broonie@kernel.org, ocfs2-devel@oss.oracle.com, piaojun <piaojun@huawei.com>, Joseph Qi <joseph.qi@huawei.com>, Jiufei Xue <xuejiufei@huawei.com>, Mark Fasheh <mfasheh@suse.de>, Joel Becker <jlbec@evilplan.org>, Junxiao Bi <junxiao.bi@oracle.com>

On Tue, 10 Oct 2017 14:06:41 -0400 Vitaly Mayatskih <v.mayatskih@gmail.com> wrote:

> * ocfs2-dlm-continue-to-purge-recovery-lockres-when-recovery
> -master-goes-down.patch
> 
> This one completely broke two node cluster use case: when one node dies,
> the other one either eventually crashes (~4.14-rc4) or locks up (pre-4.14).

Are you sure?

Are you able to confirm that reverting this patch (ee8f7fcbe638b07e8)
and only this patch fixes up current mainline kernels?

Are you able to supply more info on the crashes and lockups so that the
ocfs2 developers can understand the failures?

Thanks.
