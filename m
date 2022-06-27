Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A04DCCCA473
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jun 2022 05:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiF0FyL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jun 2022 01:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiF0FyK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jun 2022 01:54:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C52D2DC3;
        Sun, 26 Jun 2022 22:54:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B74F9CE112F;
        Mon, 27 Jun 2022 05:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A66C341C8;
        Mon, 27 Jun 2022 05:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656309245;
        bh=Sus3/9KJFbCudnP5NL9Wq/YGxqU1cqKDlw/yXzz/byE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PmnyKU2R6B3OwWkNwA71Bb3W4yu3aSzlU4JKpSGEYVhtUVgjXPiWii2v775TAVKXH
         71qSOmGElh9zC6RSYT5QQRe4TkLChzhb4joLhhlzKZVtuPRAInPSRc5/29vrUHxJJQ
         l6JnTSuBl/ebjvoqtCkynONE2ZRG51fMWyWayEE0=
Date:   Sun, 26 Jun 2022 22:54:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Junxiao Bi <junxiao.bi@oracle.com>
Cc:     "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "piaojun@huawei.com" <piaojun@huawei.com>,
        "mark@fasheh.com" <mark@fasheh.com>,
        "joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>,
        "jlbec@evilplan.org" <jlbec@evilplan.org>,
        "heming.zhao@suse.com" <heming.zhao@suse.com>,
        "ghe@suse.com" <ghe@suse.com>,
        "gechangwei@live.cn" <gechangwei@live.cn>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: + revert-ocfs2-mount-shared-volume-without-ha-stack.patch added
 to mm-hotfixes-unstable branch
Message-Id: <20220626225404.e12f34eb4d416c6e6184f9bf@linux-foundation.org>
In-Reply-To: <0D22B946-B3D7-4137-BC22-2737CA00D92A@oracle.com>
References: <20220626202113.CE8DAC34114@smtp.kernel.org>
        <0D22B946-B3D7-4137-BC22-2737CA00D92A@oracle.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, 26 Jun 2022 23:18:44 +0000 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> Thanks for merging it to mm.
> I see the “From” is “ Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>”, can you help fix that?

Thanks, I fixed that.
