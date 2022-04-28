Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E628CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 18:11:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346366AbiD1SOS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 14:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350755AbiD1SOO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 14:14:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADA2B7C6A
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 11:10:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5061260EA8
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 18:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D00C385A0;
        Thu, 28 Apr 2022 18:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651169457;
        bh=gFWlg1Z8gHQ5IFkrPoAGVu6oaiOWqO0rkUp/6TySKvA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MZ2lqL7J1zudeIezwFTSq+mN7oR1CNfQOFRHWJOCEv0jC9fdJLIJCE+2XVsheEBbA
         zAfn0EuulVaqXS6my64aPuYfZ8nHSR7s/arGJhRNCbnVsacfs+biTVpK8wsXbhpFoX
         aI0VttTwY7SP28a+giHQe/fx70f98pgKlMtziQnI=
Date:   Thu, 28 Apr 2022 11:10:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Liam Howlett <liam.howlett@oracle.com>
Cc:     "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "quic_qiancai@quicinc.com" <quic_qiancai@quicinc.com>
Subject: Re: + mm-start-tracking-vmas-with-maple-tree-fix.patch added to -mm
 tree
Message-Id: <20220428111056.063cf6c0c6f9bac2b67b4fb7@linux-foundation.org>
In-Reply-To: <20220428173510.7hfswk5v3avlxdnw@revolver>
References: <20220427225656.A5C98C385A7@smtp.kernel.org>
        <20220428173510.7hfswk5v3avlxdnw@revolver>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 28 Apr 2022 17:35:17 +0000 Liam Howlett <liam.howlett@oracle.com> wrote:

> * Andrew Morton <akpm@linux-foundation.org> [220427 18:57]:
> > 
> > The patch titled
> >      Subject: mm/mmap: fix __vma_adjust() memory leak
> > has been added to the -mm tree.  Its filename is
> >      mm-start-tracking-vmas-with-maple-tree-fix.patch
> > 
> > This patch should soon appear at
> >     https://ozlabs.org/~akpm/mmots/broken-out/mm-start-tracking-vmas-with-maple-tree-fix.patch
> > and later at
> >     https://ozlabs.org/~akpm/mmotm/broken-out/mm-start-tracking-vmas-with-maple-tree-fix.patch
> 
> Both of these links are 404 and the patch does not seem to be in
> linux-next 20220428.  Is there any chance this was missed?

We're in the process of gitifying the -mm tree and there were glitches.
Hopefully next -next will sort this out.

Please review the mm-everything branch at
git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm to check that
everything has landed correctly.

