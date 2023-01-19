Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F9AC678D6
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjASBUr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjASBTH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCB26B980
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFF0EB81FBB
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76949C433F0;
        Thu, 19 Jan 2023 01:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090978;
        bh=USR7zLjXSMDLbgr4Y9FdUvX7dMR8oNwQGG8lFpa4hzY=;
        h=Date:To:From:Subject:From;
        b=L9+AVvjSnja+5eooL3pAsmvW4jRujQMof1MDOOhvxT62Zb/OFFaqJwmrnX48/NEhm
         TPvASpvmmaQuSUG9Zi2W28L5UPsf70ixtAAS3M5lioD17aAmjvrsO07zQjrK/hOgXo
         qT3eKB8Flk7/O25YapuhNy1bSCjGIpoWuqpAvCSw=
Date:   Wed, 18 Jan 2023 17:16:18 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-types-to-akpm-mm-git-trees-entries.patch removed from -mm tree
Message-Id: <20230119011618.76949C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add types to akpm/mm git trees entries
has been removed from the -mm tree.  Its filename was
     maintainers-add-types-to-akpm-mm-git-trees-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: MAINTAINERS: add types to akpm/mm git trees entries
Date: Tue, 3 Jan 2023 18:07:50 +0000

Patch series "mm: trivial fixups".

This patchset is for trivial fixups of mm stuff on MAINTAINERS, tools/
selftests, and docs.


This patch (of 5):

Each SCM tree entry of MAINTAINERS file should have both type and
location, but akpm/mm git tree entries of 'MEMORY MANAGEMENT' and
'VMALLOC' sections of the file don't have the type.  Add the type.

Link: https://lkml.kernel.org/r/20230103180754.129637-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-add-types-to-akpm-mm-git-trees-entries
+++ a/MAINTAINERS
@@ -13474,7 +13474,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
@@ -13492,7 +13492,7 @@ R:	Christoph Hellwig <hch@infradead.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/vmalloc.h
 F:	mm/vmalloc.c
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch

