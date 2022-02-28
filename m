Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A30C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 00:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiB1ArK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 19:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiB1ArJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 19:47:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CAA3A725
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 16:46:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1701611FC
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 00:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E7EC340E9;
        Mon, 28 Feb 2022 00:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646009190;
        bh=dqneQi8yoEhqeRyVgpZw5Y6Jq14aQUWtK31l7qhsTdI=;
        h=Date:To:From:Subject:From;
        b=gHM3FSqVfdhtP45p6djSKLR4lnSsR53be1Alsiw1RMfy1sMlQA5SXkAcZTEqTSsYQ
         UY7T5keE5Yu2oJ2JVVT7uBhWmk2L0LqmELSWi/IPuX8tofe9k5Ifn+dHVZRXK+AoHR
         +FgQ5YHG9X1pmU7Njq9aEUYy5TxHGNG7hW/Zevhw=
Date:   Sun, 27 Feb 2022 16:46:29 -0800
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        sfr@canb.auug.org.au, keescook@chromium.org, mcgrof@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] maintainers-add-sysctl-next-git-tree.patch removed from -mm tree
Message-Id: <20220228004629.F1E7EC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add sysctl-next git tree
has been removed from the -mm tree.  Its filename was
     maintainers-add-sysctl-next-git-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: MAINTAINERS: add sysctl-next git tree

Add a git tree for sysctls as there's been quite a bit of work lately to
remove all the syctls out of kernel/sysctl.c and move to their respective
places, so coordination has been needed to avoid conflicts.  This tree
will also help soak these changes on linux-next prior to getting to Linus.

Link: https://lkml.kernel.org/r/20220218182736.3694508-1-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-sysctl-next-git-tree
+++ a/MAINTAINERS
@@ -15567,6 +15567,7 @@ M:	Iurii Zaikin <yzaikin@google.com>
 L:	linux-kernel@vger.kernel.org
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git sysctl-next
 F:	fs/proc/proc_sysctl.c
 F:	include/linux/sysctl.h
 F:	kernel/sysctl-test.c
_

Patches currently in -mm which might be from mcgrof@kernel.org are


