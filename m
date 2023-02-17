Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CD0C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 02:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjBQCT2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 21:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBQCT1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 21:19:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCB72E0C6
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 18:19:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 083696112C
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 02:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E205C433D2;
        Fri, 17 Feb 2023 02:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676600365;
        bh=1EOZVwwhChuK5nuAw9RwuDVe9UdsJW629SD71q262YI=;
        h=Date:To:From:Subject:From;
        b=qnaOqOIEQFpjjcPWmaAzprl5unhhQYkWqRaM25DzwFJRXJoxs50JEgY38bRzegpbh
         1F6C+LpLqCyFw7tcC7aUBpQHnwjWbC0ipyprAmnfd14vSxv36Oy8rsPyJI1B5YFBbc
         wb16nYPu+Og55fHAR8kLaygrSohlr+IRsklz36Rg=
Date:   Thu, 16 Feb 2023 18:19:24 -0800
To:     mm-commits@vger.kernel.org, glider@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-stackdepot-move-documentation-comments-to-stackdepoth-fix.patch removed from -mm tree
Message-Id: <20230217021925.5E205C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib-stackdepot-move-documentation-comments-to-stackdepoth-fix
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-move-documentation-comments-to-stackdepoth-fix.patch

This patch was dropped because it was folded into lib-stackdepot-move-documentation-comments-to-stackdepoth.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-stackdepot-move-documentation-comments-to-stackdepoth-fix
Date: Mon Feb 13 10:04:04 AM PST 2023

grammar fix, per Alexander

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/stackdepot.h~lib-stackdepot-move-documentation-comments-to-stackdepoth-fix
+++ a/include/linux/stackdepot.h
@@ -11,7 +11,7 @@
  * SLUB_DEBUG needs 256 bytes per object for that). Since allocation and free
  * stack traces often repeat, using stack depot allows to save about 100x space.
  *
- * Stack traces are never removed from stack depot.
+ * Stack traces are never removed from the stack depot.
  *
  * Author: Alexander Potapenko <glider@google.com>
  * Copyright (C) 2016 Google, Inc.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-stackdepot-move-documentation-comments-to-stackdepoth.patch
mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix.patch
mm-change-to-return-bool-for-isolate_movable_page-fix.patch
include-linux-migrateh-remove-unneeded-externs.patch

