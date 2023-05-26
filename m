Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74834C7EE2E
	for <mm-commits@archiver.kernel.org>; Fri, 26 May 2023 02:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbjEZCF7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 22:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242099AbjEZCFx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 22:05:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE07194
        for <mm-commits@vger.kernel.org>; Thu, 25 May 2023 19:05:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83ADE64C4C
        for <mm-commits@vger.kernel.org>; Fri, 26 May 2023 02:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93641C4339B;
        Fri, 26 May 2023 02:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685066748;
        bh=CZVNMtCm5jpwGorIKHM6illuNcoGDGGaYsqfZ/1LGhk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BrYVWe1MB95Ir3/gCbUm3NfEU9DuFhaAZkp+N4mXiGQe/whqg7SFqMStNaUuwKd4x
         s1VcpleE9PnchQe9/Pt8CneCI1V38CaemMd4dYW0edgXnEx9SFmedg9tp4zfe5XwIv
         ZpyOzc1Hu6tx1FMmdS43YWTMWHa2SFBwK0AI+xBU=
Date:   Thu, 25 May 2023 19:05:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        lhenriques@suse.de, junxiao.bi@oracle.com, jlbec@evilplan.org,
        ghe@suse.com, gechangwei@live.cn, ocfs2-devel@oss.oracle.com
Subject: Re: +
 ocfs2-fix-use-after-free-when-unmounting-read-only-filesystem.patch added
 to mm-hotfixes-unstable branch
Message-Id: <20230525190547.9e8d1694ede16469b5899a04@linux-foundation.org>
In-Reply-To: <efbc350b-9529-7cc1-5d96-d3261404cfa0@linux.alibaba.com>
References: <20230525205556.680DCC433EF@smtp.kernel.org>
        <efbc350b-9529-7cc1-5d96-d3261404cfa0@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 26 May 2023 09:36:25 +0800 Joseph Qi <joseph.qi@linux.alibaba.com> wrote:

> Hi Andrew,
> 
> There is an updated version v2, which describe more clearly about the
> case:
> https://lore.kernel.org/ocfs2-devel/e9fc4b2f-1fcc-7c31-f346-59eccff50f9b@linux.alibaba.com/T/#u

Sigh.  Thanks.

As you can see from the above link, the email never hit ocfs2-devel and
never hit my inbox.  I'll piece it together from your reply.

The ocfs2-devel list is really bad.  Can we move to a vger list?  Or
get some maintenance work done on ocfs2-devel?


