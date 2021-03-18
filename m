Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C55A0C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 10:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F06F64E81
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 10:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhCRKOA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Mar 2021 06:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhCRKNr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Mar 2021 06:13:47 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F89C06174A
        for <mm-commits@vger.kernel.org>; Thu, 18 Mar 2021 03:13:47 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616062426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kmVJFowN6q4WKxSlX+HsK/kcFxgL6/qetLIR8dtJBgo=;
        b=Zb6HuA3eqmYB+qbDng9cVrdylnDyY3vxvhal7jb+HnOTHNWpqXY50WfgRlMLZ7qQ5xoRJN
        1VaUReI8A5R77xOMvX76hCfGIxtfpaiDGZ5eceEhVvkcgdz/kDYb1xM8eGBsI+1YaK/836
        4acuw511nSqbN74+CetPi05rsOmFqxiCc/YkZpIBZOoznAST7+Z9cVMzAU7hG9Kkcs7Gjy
        ZzHY6NhV+P71mezOmq/4HXW3zmcNCmh/nx5PjfZ6ZofSKcDwtkuC/MNa44hqUEL+OYcbi8
        upZeDAnk5JSJIDb1PywhU352l8NMfGWXqf3QegGaWrfU59OkVADOWUMYgduWZA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616062426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kmVJFowN6q4WKxSlX+HsK/kcFxgL6/qetLIR8dtJBgo=;
        b=6PUGEz3CdVPcWZUJQV1WDHQucvcspwSWGfXQa0ACd4qZpMH14hu7w+3KBoEOxshLI4FVAT
        F3XeKZDneceDDdDw==
To:     akpm@linux-foundation.org, krzysztof.kozlowski@canonical.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject: Re: + genirq-fix-language-typos.patch added to -mm tree
In-Reply-To: <20210318005653.YRSp8WcUW%akpm@linux-foundation.org>
References: <20210318005653.YRSp8WcUW%akpm@linux-foundation.org>
Date:   Thu, 18 Mar 2021 11:13:45 +0100
Message-ID: <87r1kcwyzq.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Mar 17 2021 at 17:56, akpm wrote:
> The patch titled
>      Subject: kernel/irq/: fix language typos
> has been added to the -mm tree.  Its filename is
>      genirq-fix-language-typos.patch
>
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/genirq-fix-language-typos.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/genirq-fix-language-typos.patch

It already appeared here:

   https://lore.kernel.org/lkml/161590384374.398.6620744885292439899.tip-bot2@tip-bot2/

Thanks,

        tglx
