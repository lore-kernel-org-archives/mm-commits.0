Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A887CC677F1
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 23:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjARX7J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 18:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjARX6z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 18:58:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461424AA7E
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 15:58:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD4FD61A7C
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 23:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C84EC433D2;
        Wed, 18 Jan 2023 23:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674086294;
        bh=kVJudLU0Ezkb92KY6yO+7IhN4XS+XpZALTpNEk0tfNI=;
        h=Date:To:From:Subject:From;
        b=uW+vl0UZndeyKsBfO2h1pNGT59xVf71S/6gi+WfjkJmqmdiQCDWiKht9TtMYYOzuX
         v5+Z2heSPq6fO2/troR115QLX/p3x7YudWDt7EpxbnKpjvl4BzMnjlKri6Hz9RccpU
         PFLZYDGLVYESKnoJ9U+IqO95iPNoH68WnP5IbbrM=
Date:   Wed, 18 Jan 2023 15:58:13 -0800
To:     mm-commits@vger.kernel.org, lkp@intel.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-admin-guide-mm-numaperf-increase-depth-of-subsections-fix.patch removed from -mm tree
Message-Id: <20230118235814.2C84EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Docs/admin-guide/mm/numaperf: change title to fix duplicate label warning
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-numaperf-increase-depth-of-subsections-fix.patch

This patch was dropped because it was folded into docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/numaperf: change title to fix duplicate label warning
Date: Fri, 6 Jan 2023 19:49:27 +0000

Commit 1564fac284b1 ("Docs/admin-guide/mm/numaperf: increase depth of
subsections") in mm-unstable titled numaperf.rst as 'NUMA Performance'. 
The name overlaps with an existing subsection title of the document, so
sphinx makes below warning.

    linux/Documentation/admin-guide/mm/numaperf.rst:68: WARNING: duplicate label admin-guide/mm/numaperf:numa performance, other instance in linux/Documentation/admin-guide/mm/numaperf.rst

Fix the warning by changing the title of the document to 'NUMA Memory
Performance'.  It may look more consistent with its sibling document,
'NUMA Memory Policy'.

Link: https://lkml.kernel.org/r/20230106194927.152663-1-sj@kernel.org
Fixes: 1564fac284b1 ("Docs/admin-guide/mm/numaperf: increase depth of subsections") in mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/mm/numaperf.rst~docs-admin-guide-mm-numaperf-increase-depth-of-subsections-fix
+++ a/Documentation/admin-guide/mm/numaperf.rst
@@ -1,8 +1,8 @@
 .. _numaperf:
 
-================
-NUMA Performance
-================
+=======================
+NUMA Memory Performance
+=======================
 
 NUMA Locality
 =============
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch
mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch
maintainers-add-types-to-akpm-mm-git-trees-entries.patch
maintainers-memory-management-add-tools-vm-as-managed-files.patch
tools-vm-rename-tools-vm-to-tools-mm.patch
selftests-vm-rename-selftets-vm-to-selftests-mm.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch
mm-damon-vaddr-rename-damon_young_walk_private-page_sz-to-folio_sz.patch
mm-damon-vaddr-support-folio-of-neither-hpage_pmd_size-nor-page_size.patch
mm-damon-vaddr-record-appropriate-folio-size-when-the-access-is-not-found.patch
mm-damon-paddr-rename-damon_pa_access_chk_result-page_sz-to-folio_sz.patch
mm-damon-paddr-remove-folio_sz-field-from-damon_pa_access_chk_result.patch
mm-damon-paddr-remove-damon_pa_access_chk_result-struct.patch
mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch

