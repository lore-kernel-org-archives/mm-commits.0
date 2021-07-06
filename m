Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C8FC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FD5661CA3
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhGFTZB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230012AbhGFTZA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69A2E61C9D;
        Tue,  6 Jul 2021 19:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599340;
        bh=T9PMwGPq9cI8qJB8PvHzRS0t+gvCE7ZcTlex4PV+QZ8=;
        h=Date:From:To:Subject:From;
        b=lqT0ZsQ+JmWLkmo9Os/++Ynmf9rj8nhK1wg0ryrDT96IH+MKGisZjJr9yIBfFUFwF
         Nl6YRNnxW178hHUjQqzUSjvlt0qEK5pwgMM56YjY/lc/TCtbHTS4s8Qt2qmDX2f0NK
         LhaFbMma18xpQj8BppdEnjOWiMf1+vfe9STdr0Uo=
Date:   Tue, 06 Jul 2021 12:22:20 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 =?US-ASCII?Q?maintainers-add-myself-as-designated-reviewer-for-generic-?=
 =?US-ASCII?Q?string-library.patch?= removed from -mm tree
Message-ID: <20210706192220.3zJF0hAku%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add myself as designated reviewer for generic string library
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-designated-reviewer-for-generic-string-library.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


