Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B5FC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D862087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817429;
	bh=/hLAHyoRgEY065SjjS+30Eux3/9wpKNX2QsLKa8KDVY=;
	h=Date:From:To:Subject:In-Reply-To:References:Reply-To:List-ID:
	 From;
	b=PsW/OkqHKaqpkLfSbJqNoRSFI35yKNxvgMpvyjA3NBT8bIQDCPHjivjmu8PAdanIA
	 GQxMJYt7c7C3A2KSEFYK16mBdEsMxu7LG98OQjJKRhp9r1viYBqjxwLFAceT9Vty+w
	 0DLzGthapMxDtmGQLDhry+Vfnj4MZoA5doBZltLA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732335AbgJPDDt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:03:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDDt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:03:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 784A020789;
        Fri, 16 Oct 2020 03:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817428;
        bh=/hLAHyoRgEY065SjjS+30Eux3/9wpKNX2QsLKa8KDVY=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=ku+43Ap78KRKOTjoe02TQt8QIJ46wdBVZjupjxaURT4bgc+9DId2f8TCv3hArThuB
         yzXRIDm6v+hsqnSPNCfLE+ib/0rfWQDLhQkXGgmvSLM3zj5agsoX/Yz+6QqOSBTrbV
         Q7Y9Ar5jzVE0Naf5FW8QIf/w3f0C+efhnvlqtziE=
Date:   Thu, 15 Oct 2020 20:03:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: Re: incoming
Message-Id: <20201015200347.1c3e98ee82432d0173167bc6@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
References: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

And... I forgot to set in-reply-to :(

Shall resend, omitting linux-mm.
