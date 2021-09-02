Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE39C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85CC860F12
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243371AbhIBVua (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232060AbhIBVua (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:50:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 281A6610A0;
        Thu,  2 Sep 2021 21:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619371;
        bh=nknJb7mWRdpA2y5HBcUdW5SY4nzM8TLXCUuytbmVwIE=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=zI7vb9pfnQrghewtT8J2B+p1usH3FuvKpzbUSIsUbGryanPGb6EtPbIjvzJyl5Tlk
         J7XrSUW0AZG1Cw5XKZ7KZw9j20LyGhg1P/QoLyN1ZdvQF4zQ7YS2lomDtvF5/3gxxU
         oyL/dsJN2vPD6Yk9btfqGlN1SK1S/Ulp+tfJRHy0=
Date:   Thu, 2 Sep 2021 14:49:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org
Subject: Re: incoming
Message-Id: <20210902144930.93fc9a8e338f4836317333cf@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
References: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 2 Sep 2021 14:48:20 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> 212 patches, based on 4a3bb4200a5958d76cc26ebe4db4257efa56812b.

Make that "based on 7d2a07b769330c34b4deabeed939325c77a7ec2f".
