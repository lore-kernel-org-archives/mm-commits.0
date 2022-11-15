Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA0FC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 23:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiKOXYR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 18:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiKOXXt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 18:23:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6E717A9D
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 15:23:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 142E461766
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 23:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BBDC433D7;
        Tue, 15 Nov 2022 23:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668554627;
        bh=vkZnWAmm/IK1wUwZowolBLc4bOxIbuZqvKEiIkFqy2s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xo/HPRH8zvuRH2lJ7l5YPw3z1Z2cVhePzwvbRFGJOnYUB7fjEuiYut5NY3jbcYWbg
         zZKAGEN8gxnm7wRlMg1t2YrZ8ZMjyhYekr8GxNF6WzSgOdGyCgYKkOexulFCOtDVyC
         8c9hk7v7xXiuSgmYs+8pKvpnzZrek7WzXYL1Gxyw=
Date:   Tue, 15 Nov 2022 15:23:46 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     mm-commits@vger.kernel.org, vschneid@redhat.com, vbabka@suse.cz,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, sander@svanheule.net, peterz@infradead.org,
        paulmck@kernel.org, linux@rasmusvillemoes.dk,
        klimov.linux@gmail.com, geert@linux-m68k.org, ebiggers@google.com,
        dvyukov@google.com, andriy.shevchenko@linux.intel.com
Subject: Re: [merged mm-nonmm-stable]
 cpumask-limit-visibility-of-force_nr_cpus.patch removed from -mm tree
Message-Id: <20221115152346.2c97f5be50e58022d7ef87db@linux-foundation.org>
In-Reply-To: <Y3QdFrd7Lld5XCE7@yury-laptop>
References: <20221115223220.D75F7C433C1@smtp.kernel.org>
        <Y3QdFrd7Lld5XCE7@yury-laptop>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 15 Nov 2022 15:13:26 -0800 Yury Norov <yury.norov@gmail.com> wrote:

> On Tue, Nov 15, 2022 at 02:32:20PM -0800, Andrew Morton wrote:
> > 
> > The quilt patch titled
> >      Subject: cpumask: limit visibility of FORCE_NR_CPUS
> > has been removed from the -mm tree.  Its filename was
> >      cpumask-limit-visibility-of-force_nr_cpus.patch
> > 
> > This patch was dropped because it was merged into the mm-nonmm-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Andrew,
> 
> I need to send v3 for this.

argh, it's been a month.

> Can you please exclude this?

I'll take a look when you send v3.


