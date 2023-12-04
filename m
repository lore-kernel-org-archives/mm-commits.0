Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B4BC4167B
	for <mm-commits@archiver.kernel.org>; Mon,  4 Dec 2023 19:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjLDT4e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Dec 2023 14:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbjLDT4e (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Dec 2023 14:56:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D0C101
        for <mm-commits@vger.kernel.org>; Mon,  4 Dec 2023 11:56:40 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352C3C433C7;
        Mon,  4 Dec 2023 19:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701719800;
        bh=BXZLfXfMZAtbKLlYIrFK7JQJaLV9zfOD9cEHa7DV1yc=;
        h=Date:To:From:Subject:From;
        b=Bg7Fa2bwf009MpvzHdzkeSeHplha3RdC4maEtec/pJL55m17Fjirubu0tGH8JPEs/
         2FyOGLoa7QQWZNpIB3nnBYgNa3D73HTYKN3tgpcz3yjzpDwIAIxzcIbdZ2NCNQh+ko
         50ascW6YAM+4LZh4hfosrD69xkQf0VWnLP8kylm8=
Date:   Mon, 04 Dec 2023 11:56:39 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        fancer.lancer@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-extend-init-unavailable-range-doc-info-v2.patch added to mm-unstable branch
Message-Id: <20231204195640.352C3C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mm_initc-extend-init-unavailable-range-doc-info-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-extend-init-unavailable-range-doc-info-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-extend-init-unavailable-range-doc-info-v2.patch

This patch will later appear in the mm-unstable branch at
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
From: Serge Semin <fancer.lancer@gmail.com>
Subject: mm-mm_initc-extend-init-unavailable-range-doc-info-v2
Date: Sat, 2 Dec 2023 14:18:52 +0300

update per Mike

Link: https://lkml.kernel.org/r/20231202111855.18392-1-fancer.lancer@gmail.com
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-extend-init-unavailable-range-doc-info-v2
+++ a/mm/mm_init.c
@@ -796,7 +796,7 @@ overlap_memmap_init(unsigned long zone,
  * - physical memory bank size is not necessarily the exact multiple of the
  *   arbitrary section size
  * - early reserved memory may not be listed in memblock.memory
- * - memory mapped IO space
+ * - non-memory regions covered by the contigious flatmem mapping
  * - memory layouts defined with memmap= kernel parameter may not align
  *   nicely with memmap sections
  *
_

Patches currently in -mm which might be from fancer.lancer@gmail.com are

mm-mm_initc-extend-init-unavailable-range-doc-info.patch
mm-mm_initc-extend-init-unavailable-range-doc-info-v2.patch
mm-mm_initc-append-newline-to-the-unavailable-ranges-log-message.patch

