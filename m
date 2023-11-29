Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD324C4167B
	for <mm-commits@archiver.kernel.org>; Wed, 29 Nov 2023 02:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjK2CKh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Nov 2023 21:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjK2CKg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Nov 2023 21:10:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E005D172E
        for <mm-commits@vger.kernel.org>; Tue, 28 Nov 2023 18:10:42 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797E7C433C7;
        Wed, 29 Nov 2023 02:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701223842;
        bh=dXnWci39XHdbJAUe4jiG1TeRC2XfoQ1LyeWWS647UIk=;
        h=Date:To:From:Subject:From;
        b=w5+eIhcD9+qjaj3nJBu0suY+tp/EfqE3GKwf4kv+h0GFWRZY4deEPhZVz680uLOx4
         JQxL5NdTwtGMgL0S49ih5BBT1vGAtPYrncBrQGOF/4ACwSlciMgdUc62a746toqqGm
         K+/f9i2FaeHwCXs5kJiH7de7WBYBncuT03HWP1UM=
Date:   Tue, 28 Nov 2023 18:10:41 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        linux@rasmusvillemoes.dk, herbert@gondor.apana.org.au,
        damian.muszynski@intel.com, andriy.shevchenko@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + units-add-missing-header.patch added to mm-nonmm-unstable branch
Message-Id: <20231129021042.797E7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: units: add missing header
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     units-add-missing-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/units-add-missing-header.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
units-add-missing-header.patch

