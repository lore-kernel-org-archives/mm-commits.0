Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CACC11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE9F861476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbhGAB6D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhGAB6C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D0006141A;
        Thu,  1 Jul 2021 01:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104532;
        bh=Xgv0iCo6p/cj/ROz+yQ0rE+g2nRQ5V5X6Lszzs53qLo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0VqTRTv6VlA6qNNHBe1aR+3rDpYhtspNTqfxMXuPXiZWP4lsI2vHwqgyV90wq7dBR
         3t5LJtgKZEgPTz+B5apj7/mtyH9GHcIHSDW4IFDZ/Me0qPisHCeRxln4oQAwDtz6iL
         brhczsRkIVKsa8onOkzCLW1CPeA062OSQezOIs84=
Date:   Wed, 30 Jun 2021 18:55:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 157/192] MAINTAINERS: add myself as designated
 reviewer for generic string library
Message-ID: <20210701015532.TM-YdEfeZ%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: MAINTAINERS: add myself as designated reviewer for generic string library

Add myself as designated reviewer for generic string library.

Link: https://lkml.kernel.org/r/20210504180819.73127-11-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/MAINTAINERS~maintainers-add-myself-as-designated-reviewer-for-generic-string-library
+++ a/MAINTAINERS
@@ -7648,6 +7648,14 @@ L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/input/touchscreen/resistive-adc-touch.c
 
+GENERIC STRING LIBRARY
+R:	Andy Shevchenko <andy@kernel.org>
+S:	Maintained
+F:	lib/string.c
+F:	lib/string_helpers.c
+F:	lib/test_string.c
+F:	lib/test-string_helpers.c
+
 GENERIC UIO DRIVER FOR PCI DEVICES
 M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	kvm@vger.kernel.org
_
