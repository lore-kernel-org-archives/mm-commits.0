Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CDEC54EED
	for <mm-commits@archiver.kernel.org>; Sun, 29 Jan 2023 22:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbjA2WcA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 29 Jan 2023 17:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjA2WcA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 29 Jan 2023 17:32:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0091BACE
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 14:31:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8049B80D9B
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 22:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1CCC433EF;
        Sun, 29 Jan 2023 22:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675031516;
        bh=g58zyKfsC+Ez3Lq6zBqJ4/ydbICpaR24wuw4gfQMKcM=;
        h=Date:To:From:Subject:From;
        b=cz8SGEfsywvZKHd38sUqrqfErGV42EI6eLYWTcCz5Ps3+AoaKbrd0EiEoCGPHFr24
         sfCz96e3lgcWb5y4XDowsdUVhIrwrt/qYVJXS7VOgXCEsdD34Pali9NldBPiLjqZOe
         eBngAFwtDqpt189GKhI2DMRUNaFo5gQeJSfl5320=
Date:   Sun, 29 Jan 2023 14:31:55 -0800
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, elver@google.com,
        dvyukov@google.com, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-kconfig-fix-spellos.patch removed from -mm tree
Message-Id: <20230129223156.7F1CCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: Kconfig: fix spellos
has been removed from the -mm tree.  Its filename was
     lib-kconfig-fix-spellos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: Kconfig: fix spellos
Date: Tue, 24 Jan 2023 10:16:55 -0800

Fix spelling in lib/ Kconfig files.
(reported by codespell)

Link: https://lkml.kernel.org/r/20230124181655.16269-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/Kconfig.debug~lib-kconfig-fix-spellos
+++ a/lib/Kconfig.debug
@@ -1917,7 +1917,7 @@ config FUNCTION_ERROR_INJECTION
 	help
 	  Add fault injections into various functions that are annotated with
 	  ALLOW_ERROR_INJECTION() in the kernel. BPF may also modify the return
-	  value of theses functions. This is useful to test error paths of code.
+	  value of these functions. This is useful to test error paths of code.
 
 	  If unsure, say N
 
--- a/lib/Kconfig.kcsan~lib-kconfig-fix-spellos
+++ a/lib/Kconfig.kcsan
@@ -194,7 +194,7 @@ config KCSAN_WEAK_MEMORY
 	  Enable support for modeling a subset of weak memory, which allows
 	  detecting a subset of data races due to missing memory barriers.
 
-	  Depends on KCSAN_STRICT, because the options strenghtening certain
+	  Depends on KCSAN_STRICT, because the options strengthening certain
 	  plain accesses by default (depending on !KCSAN_STRICT) reduce the
 	  ability to detect any data races invoving reordered accesses, in
 	  particular reordered writes.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

freevxfs-kconfig-fix-spelling.patch
freevxfs-fix-kernel-doc-warnings.patch
ntfs-fix-multiple-kernel-doc-warnings.patch
userns-fix-a-structs-kernel-doc-notation.patch
cramfs-kconfig-fix-spelling-punctuation.patch

