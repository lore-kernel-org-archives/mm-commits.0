Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31FBC433ED
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 01:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD65E613C9
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 01:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243189AbhDFBx7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Apr 2021 21:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242237AbhDFBx6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 5 Apr 2021 21:53:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65215613C6;
        Tue,  6 Apr 2021 01:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617674031;
        bh=v3Ot+dv1Y04U2yzie5Ets9i3PhYNwB5JyZR/K2WOiuM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CR7ijdG3W7usRXVl1IP4Z5hVXojcrJEOhayMtSIhApMD60moUfTl0A7Avwkc7hpOs
         WZgU05PcQFjF1pVKI0XOkj2TiJT5VK3fXkLy6cQDq29RDLXnBlKFYvnZRD/3/XW5+r
         b9l0LkYFtpDmJGOOx1Wk4pMzVB19pZJBlgMiiS2M=
Date:   Mon, 5 Apr 2021 18:53:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     john.p.donnelly@oracle.com
Cc:     andreyknvl@google.com, bhe@redhat.com,
        christian.brauner@ubuntu.com, colin.king@canonical.com,
        corbet@lwn.net, dyoung@redhat.com, frederic@kernel.org,
        gpiccoli@canonical.com, jpoimboe@redhat.com, keescook@chromium.org,
        masahiroy@kernel.org, mchehab+huawei@kernel.org,
        mike.kravetz@oracle.com, mingo@kernel.org,
        mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        rppt@kernel.org, saeed.mirzamohammadi@oracle.com,
        samitolvanen@google.com, sboyd@kernel.org, tglx@linutronix.de,
        vgoyal@redhat.com, yifeifz2@illinois.edu
Subject: Re: +
 kernel-crash_core-add-crashkernel=auto-for-vmcore-creation.patch added to
 -mm tree
Message-Id: <20210405185349.ce46c0272a1944c2a8a84a27@linux-foundation.org>
In-Reply-To: <7a906327-a2f3-14b4-d59f-26e4273ed1f7@oracle.com>
References: <20210304003559.ZchAywVJv%akpm@linux-foundation.org>
        <7a906327-a2f3-14b4-d59f-26e4273ed1f7@oracle.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 5 Apr 2021 17:47:21 -0500 john.p.donnelly@oracle.com wrote:

> > Patches currently in -mm which might be from saeed.mirzamohammadi@oracle.com are
> > 
> > kernel-crash_core-add-crashkernel=auto-for-vmcore-creation.patch
> > 
> 
> 
> Hi,
> 
> When  will this appear in a build ?

It's in linux-next now and I expect it will appear in Linus's tree for
5.13-r1.
