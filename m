Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E7FC433E6
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 22:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D3CB22512
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 22:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbhADWR0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 17:17:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbhADWR0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 17:17:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CB2D22512;
        Mon,  4 Jan 2021 22:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609798606;
        bh=20k1C8b1bfnDLBUtJ+lxsA6G1nvgNK/gdCU7+HqIqH8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mpy9HsaKv3WT6BEZvknl3GrhxF9RWaXKx5XQc5A9JJ8amdc5xBjF9UD1VcQLGkmVO
         jLDzhJ24gL5ufM9w5XqV2obYG3JiIsQwrkC1TYBKCmzfn3UN0qeTS5WKrfIExSGJOc
         GHTpLuHfna55CLNKJWENDC2Xd0TbqF1G/t7TtniY=
Date:   Mon, 4 Jan 2021 14:16:45 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     johannes.czekay@fau.de, mm-commits@vger.kernel.org,
        nicolai.fischer@fau.de
Subject: Re: + checkpatch-kconfig-enforce-help-text-indentation.patch added
 to -mm tree
Message-Id: <20210104141645.a170adb73d48db0c422e1f14@linux-foundation.org>
In-Reply-To: <a1f2f49b9ea565893fb5c86989c14d7e653abd76.camel@perches.com>
References: <20210104211237.3Iy7io4dd%akpm@linux-foundation.org>
        <a1f2f49b9ea565893fb5c86989c14d7e653abd76.camel@perches.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 04 Jan 2021 13:49:11 -0800 Joe Perches <joe@perches.com> wrote:

> I think you should wait to apply these until
> I ack/nak them.

At version 3 I assume you've already gone a couple of rounds on them and
things are good-enough.

> Nak.

Oh well.
