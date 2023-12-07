Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244BFC10F05
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 00:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442960AbjLGANu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 19:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442100AbjLGANl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 19:13:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FB018D
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 16:13:40 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B12C433CB;
        Thu,  7 Dec 2023 00:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701908020;
        bh=mgFw7RaTm1lcY60xz6d+lo7vpMdcswH1BF5kMAYGGt0=;
        h=Date:To:From:Subject:From;
        b=sJYcW/71VDjSE/zOxw/F2WxK5RnbZyvSfC++thosR5skzcNrBgmLFnrhFitJJwMtD
         Vgmc3HgwOYsz6i/f6RHVf5vzWG9FStBxMQqFgMJJhZEESWP+uRUsRHBAoD5fyTEnEf
         qGhk0BZCA7ZZf5h6n6QVcVuQYV3YhdfOSfoD6bb0=
Date:   Wed, 06 Dec 2023 16:13:39 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        linux@rasmusvillemoes.dk, herbert@gondor.apana.org.au,
        damian.muszynski@intel.com, andriy.shevchenko@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] units-add-missing-header.patch removed from -mm tree
Message-Id: <20231207001340.55B12C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: units: add missing header
has been removed from the -mm tree.  Its filename was
     units-add-missing-header.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: units: add missing header
Date: Tue, 28 Nov 2023 19:44:03 +0200

BITS_PER_BYTE is defined in bits.h.

Link: https://lkml.kernel.org/r/20231128174404.393393-1-andriy.shevchenko@linux.intel.com
Fixes: e8eed5f7366f ("units: Add BYTES_PER_*BIT")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Damian Muszynski <damian.muszynski@intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/units.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/units.h~units-add-missing-header
+++ a/include/linux/units.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_UNITS_H
 #define _LINUX_UNITS_H
 
+#include <linux/bits.h>
 #include <linux/math.h>
 
 /* Metric prefixes in accordance with Système international (d'unités) */
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

mm-list_lru-update-kernel-documentation-to-follow-the-requirements.patch

