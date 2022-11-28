Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469B1C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 11:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiK1Lbl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 06:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiK1Lbl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 06:31:41 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DB4115A
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 03:31:39 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669635098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2wkQD/SCsKoMXfYvJifSW7lR7w444ZRbh/Jh3gIQ8+E=;
        b=Sg110+MQQcm8RvDP/CXp5mo6zK++mAFUVAIDF8telaRa+MEk0fkfYkBNribHeT4nXKAoLH
        FLU6VhskYZ6OdO2WtwM/d026BmVyeLpPGjldL0nU8P9ONln18g+QZmMLJZQU464bDnvOYP
        K5grNMUK9SFf7baiSLx5f67afX2RCJd25khR2eCwsFoYJPyy+aVMyfMKJnocQKSkUMjWJW
        BywphQepKto74ylKKjlkyLra0BxcNzfLwAfOmtgNMXS6wnTTCuH2A3U2J7FrabEN82XfWm
        iCbP1rDgb7iWdGu97J88STUwcvDMqYpv/UxnajBzoudW/1O2T5bSUqzJbbWgfA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669635098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2wkQD/SCsKoMXfYvJifSW7lR7w444ZRbh/Jh3gIQ8+E=;
        b=nRMMGuSA3siZCIQAZg0qoRZh/fhbAmcCWKrqjosRxC10rahC5dfPCqOJp5foYyuL6NWWyQ
        MhnlgnRD/FX+yfAA==
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        akpm@linux-foundation.org
Subject: Re: + irqreturnh-fix-kernel-doc-warnings.patch added to
 mm-nonmm-unstable branch
In-Reply-To: <20221124222417.30988C433D7@smtp.kernel.org>
References: <20221124222417.30988C433D7@smtp.kernel.org>
Date:   Mon, 28 Nov 2022 12:31:37 +0100
Message-ID: <87fse3wc12.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Nov 24 2022 at 14:24, Andrew Morton wrote:
> The patch titled
>      Subject: irqreturn.h: fix kernel-doc warnings
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      irqreturnh-fix-kernel-doc-warnings.patch

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=irq/core&id=f2756526450d19bca28714565062a8f286c05049
