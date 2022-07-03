Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684E2C433EF
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 20:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiGCUQc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 16:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGCUQb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 16:16:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928EB5F55
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 13:16:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B703611B5
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 20:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1428AC341C6;
        Sun,  3 Jul 2022 20:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656879389;
        bh=WJDGEFw8UEg8uXPXwTKr8J/LN7i2IxHb7CM+PUz+dLM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UXJcacL5vNCnWTzFr5JE4nzrCqcmjWIcX7tZdZjx6mUZAFAl3qKZzw7nW5KyrsuWQ
         bYzh5Lh0NVuTMqDVbVs7F51Vh2gLt6kx3+ZQ2eVbz1mZmt0pXYaIwi41/m9yRThzhk
         X2p9+hcam9rebEGEFjrNVuBNJFIBiAJKpdsk95oQ=
Date:   Sun, 3 Jul 2022 13:16:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Sander Vanheule <sander@svanheule.net>
Cc:     mm-commits@vger.kernel.org, yury.norov@gmail.com,
        vschneid@redhat.com, tglx@linutronix.de, peterz@infradead.org,
        mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        elver@google.com, dave.hansen@linux.intel.com, bp@alien8.de,
        andriy.shevchenko@linux.intel.com
Subject: Re: + lib-test-introduce-cpumask-kunit-test-suite.patch added to
 mm-nonmm-unstable branch
Message-Id: <20220703131628.b998d754fc5de4235151258d@linux-foundation.org>
In-Reply-To: <0b414dbcf5bb3fb34ff7adfdb6a2139c202b137b.camel@svanheule.net>
References: <20220702203945.6D981C34114@smtp.kernel.org>
        <0b414dbcf5bb3fb34ff7adfdb6a2139c202b137b.camel@svanheule.net>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, 03 Jul 2022 09:23:19 +0200 Sander Vanheule <sander@svanheule.net> wrote:

> > > From: Sander Vanheule <sander@svanheule.net>
> > > Subject: lib/test: ontroduce cpumask KUnit test suite
> 
> Something went wrong here, because the subject changed from "Introduce" to "ontroduce". I also
> noticed that the capitalisation after the prefix was removed for all but the second patch. I'll do
> lowercase for the next series revision, so no (manual) fixups are required.

oops, fixed.

Capitalization after a colon is somewhat incorrect, less correct than not doing
it.  Shrug, I mainly perfer it for consistency.
