Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EF6EE49AA
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjHUUjb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbjHUUjV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827AA139
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64D8C64A1B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7D2C433C7;
        Mon, 21 Aug 2023 20:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650356;
        bh=nPZj4wRrNbQPQIoiNf8AtgPAfh/pGUuADeypPJwUKiU=;
        h=Date:To:From:Subject:From;
        b=fFkFdLaKch+b2tBL2cY12pK1FRc4HknkXoiMKPZob9R769joTgH+pdYQt/lxq2tFE
         tBQS5VY0SWJh5v0WdVdvL0HfT3xQn9Ho78DfORwYpls/K0Bk51o/ynJN/0E0fNrbi2
         Fn33+CBQ/a8YSthh2BY2CCrf2tbgnS0M2Eq/68PA=
Date:   Mon, 21 Aug 2023 13:39:16 -0700
To:     mm-commits@vger.kernel.org, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-remove-unused-page_exth-from-vmstat.patch removed from -mm tree
Message-Id: <20230821203916.BA7D2C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmstat: remove unused page_ext.h from vmstat
has been removed from the -mm tree.  Its filename was
     mm-vmstat-remove-unused-page_exth-from-vmstat.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/vmstat: remove unused page_ext.h from vmstat
Date: Mon, 17 Jul 2023 19:32:26 +0800

No page_ext function or structure is used in vmstat.  Just remove page_ext
header from vmstat.

Link: https://lkml.kernel.org/r/20230717113227.1897173-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstat-remove-unused-page_exth-from-vmstat
+++ a/mm/vmstat.c
@@ -26,7 +26,6 @@
 #include <linux/writeback.h>
 #include <linux/compaction.h>
 #include <linux/mm_inline.h>
-#include <linux/page_ext.h>
 #include <linux/page_owner.h>
 #include <linux/sched/isolation.h>
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


