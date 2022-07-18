Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195A8C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 22:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbiGRWK6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Jul 2022 18:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbiGRWK6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Jul 2022 18:10:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF9023164;
        Mon, 18 Jul 2022 15:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41BE961522;
        Mon, 18 Jul 2022 22:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142D1C341C0;
        Mon, 18 Jul 2022 22:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658182255;
        bh=wjCqlJb5mdLBg9S96HrZmUtZ7wJPBB2quUuE+28hv4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vVK3HRZ6g311Y9K7idM8LHeZDynX8ZIuy0qmRe8eaWJsQ83NckueTCoPjiFVBamVH
         T5WJc3kGJnN1BebweB8lHyLOw+kGMd3TkzUrlhfMtI1DpPgTDPETHP2g75MVJZxQV/
         gMeNROIVBXfMIs/HoRGxh1XR0Mp7oOGrXKQ2VF3s=
Date:   Mon, 18 Jul 2022 15:10:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Junxiao Bi <junxiao.bi@oracle.com>
Cc:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, heming.zhao@suse.com, ghe@suse.com,
        gechangwei@live.cn, ocfs2-devel@oss.oracle.com
Subject: Re: [merged mm-hotfixes-stable]
 revert-ocfs2-mount-shared-volume-without-ha-stack.patch removed from -mm
 tree
Message-Id: <20220718151054.26c12e2f2c846df400b3dda5@linux-foundation.org>
In-Reply-To: <70bfaa1f-9a33-406f-3998-e185daea48b3@oracle.com>
References: <20220717043751.51CD1C341C0@smtp.kernel.org>
        <70bfaa1f-9a33-406f-3998-e185daea48b3@oracle.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 18 Jul 2022 11:07:11 -0700 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> Hi Andrew,
> 
> Can you help fix below "From:" to "From: Junxiao Bi <junxiao.bi@oracle.com>"
> 

OK, fixed.
