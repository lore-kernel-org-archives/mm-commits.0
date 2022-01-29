Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627C3C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 06:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240270AbiA2GX1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 29 Jan 2022 01:23:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40538 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbiA2GX1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 29 Jan 2022 01:23:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9575460B5E
        for <mm-commits@vger.kernel.org>; Sat, 29 Jan 2022 06:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE89C340E5;
        Sat, 29 Jan 2022 06:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643437406;
        bh=+t3A3Nweq0PTg/zcOnnYeRP7AL/YzgoKiBjooMAan5I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LJHnXn31w9P6S0G2FnB0f8Jq4uW9vhpePHGzcna0gfbKPGatYbVf5Xryl8OEe7CXn
         gnuJW7/MNia9INcQsZge+N8k6LsHiKYDDiGRAiIG5ynl2eZpso0jYuCWWKggFjpb6G
         BSwEs51mPTh4X9h0/3Hy3kzFUWlfDC8+8gXfwsOo=
Date:   Fri, 28 Jan 2022 22:23:24 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: Re: incoming
Message-Id: <20220128222324.58a4b077da5cc422563799a6@linux-foundation.org>
In-Reply-To: <YfTBvW4sE1+J5YG3@casper.infradead.org>
References: <20220128181341.2103de95948608a65958ae40@linux-foundation.org>
        <YfTBvW4sE1+J5YG3@casper.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, 29 Jan 2022 04:25:33 +0000 Matthew Wilcox <willy@infradead.org> wrote:

> On Fri, Jan 28, 2022 at 06:13:41PM -0800, Andrew Morton wrote:
> > 12 patches, based on 169387e2aa291a4e3cb856053730fe99d6cec06f.
>   ^^
> 
> I see 7?

Crap, sorry, ignore all this, shall redo tomorrow.

(It wasn't a good day over here.  The thing with disk drives is that
the bigger they are, the harder they fall).

