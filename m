Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1FCC433E3
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 04:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADCE061A1D
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 04:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhCYEiS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Mar 2021 00:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229822AbhCYEh5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Mar 2021 00:37:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAE2561A1B;
        Thu, 25 Mar 2021 04:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616647076;
        bh=RwyS4hkDiMkGXYSHcwPCryzHPN4OkUlD64/YVCEtEr0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Djt5KkpCrXaXa5zwK1AKOQDug5mFm8h8XjkCcW16KLFmk6nv8nyYlma96+A6IY/Bo
         bvI6JHZNBfYFpu7+7Vl8pzDzsAyYj6RE45R/b2xqKAXo4CNIQLRnG67kNoxXLKvfeU
         E25e4zrrUCZwH8YhdJBtPtVjymKroQCa7Z4TJJaY=
Date:   Wed, 24 Mar 2021 21:37:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 14/14] mailmap: update Andrey Konovalov's email
 address
Message-ID: <20210325043756.6wlU_Agaw%akpm@linux-foundation.org>
In-Reply-To: <20210324213644.bf03a529aec4ef9580e17dbc@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: mailmap: update Andrey Konovalov's email address

Use my personal email, the @google.com one will stop functioning soon.

Link: https://lkml.kernel.org/r/ead0e9c32a2f70e0bde6f63b3b9470e0ef13d2ee.1616107969.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-andrey-konovalovs-email-address
+++ a/.mailmap
@@ -36,6 +36,7 @@ Andrew Morton <akpm@linux-foundation.org
 Andrew Murray <amurray@thegoodpenguin.co.uk> <amurray@embedded-bits.co.uk>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <andrew.murray@arm.com>
 Andrew Vasquez <andrew.vasquez@qlogic.com>
+Andrey Konovalov <andreyknvl@gmail.com> <andreyknvl@google.com>
 Andrey Ryabinin <ryabinin.a.a@gmail.com> <a.ryabinin@samsung.com>
 Andrey Ryabinin <ryabinin.a.a@gmail.com> <aryabinin@virtuozzo.com>
 Andy Adamson <andros@citi.umich.edu>
_
