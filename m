Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51119C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjDRXkg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjDRXkM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:40:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D043513F89
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:38:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D3DE628CA
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4971C433EF;
        Tue, 18 Apr 2023 23:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681861079;
        bh=I+8tfW7h7dwDb9vC4LWzztijr2ViMP6reYfcyA2zdKI=;
        h=Date:To:From:Subject:From;
        b=NXBGlQCfJRvhcw0xyKLKWutMHwDvxBS9RmkBetvfCmv47ZUZbhMGkD1H/GzE8bP0d
         7vT8TXf0wdA1dAheNEFbGAEzh1m4LSy+3HYcRJyZEmj2In6Kr9PIKV60/+ZKpNAOQB
         KUh0lJWJwmdlUSdrbvWVRwKwYoRZedJfHZu/UBeg=
Date:   Tue, 18 Apr 2023 16:37:59 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        pmladek@suse.com, kbingham@kernel.org, john.ogness@linutronix.de,
        jan.kiszka@siemens.com, development@efficientek.com,
        antonio.borneo@foss.st.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix.patch removed from -mm tree
Message-Id: <20230418233759.C4971C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix
has been removed from the -mm tree.  Its filename was
     scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix.patch

This patch was dropped because it was folded into scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix
Date: Wed Apr 12 12:20:00 PM PDT 2023

add SPDX-License-Identifier

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Antonio Borneo <antonio.borneo@foss.st.com>
Cc: Glenn Washburn <development@efficientek.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/proc.py |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/gdb/linux/proc.py~scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix
+++ a/scripts/gdb/linux/proc.py
@@ -1,3 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
 #
 # gdb helper commands and functions for Linux kernel debugging
 #
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers.patch

