Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E98C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 20:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64D47616EA
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 20:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhEKUsP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 16:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEKUsO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 16:48:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C9BA6162B;
        Tue, 11 May 2021 20:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620766026;
        bh=5ajF/e3Oh50kmOZO7dH7OG9SReKgDJLtmpQBJCZ7sr8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q7d6sDUuiRdvqhu7T5xq/+QwC+3+6FncciMgCmK21iJKRy6tDx4nniAv6S6qt3wC2
         bt510CCdp4XPAe7vXWyIkTt2OxMp7Vh3xVFjLAg9oyq8p/mHqBYdcwQ2LZbguek4KT
         Vf3wen2MEyKJBVjhx4mThCqf1VCiGtszaQXFO1ws=
Date:   Tue, 11 May 2021 13:47:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     broonie@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: mmotm 2021-05-10-21-46 uploaded (mm/*)
Message-Id: <20210511134705.ef543a2ff6022f1ad0154a30@linux-foundation.org>
In-Reply-To: <e50de603-ab1d-72f7-63f5-c1fc92c5c7be@infradead.org>
References: <20210511044719.tWGZA2U3A%akpm@linux-foundation.org>
        <e50de603-ab1d-72f7-63f5-c1fc92c5c7be@infradead.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 11 May 2021 12:39:00 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> Lots of various mm/ build errors:

Huh, It Worked For Me (tm).   Can you please share the .config?
