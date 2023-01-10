Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58CDC46467
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 22:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbjAJWq0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 17:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbjAJWlh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 17:41:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AA25F4B2
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 14:41:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1EAD61921
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 22:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FC2C433D2;
        Tue, 10 Jan 2023 22:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673390494;
        bh=eFg0ipQC28yuhKyLm4laO4NxpBD6yt60tZD/g1vREjc=;
        h=Date:To:From:Subject:From;
        b=R+xCGy7b6Wnh28/Q5pSKz1N7gxr3lSEZXZTGfDPxT54hzFZMUVoRmBYaidmbnyf8Q
         RhDFpBL71e50CozohFwEzEksAAY6+LE2O5/swf7fByqM5EWdjOs3gLieVJPmHMY4JN
         W3ALFTKi3FIvJVubJTnkV8Yupas3V/TABsFNbKEM=
Date:   Tue, 10 Jan 2023 14:41:33 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-damon-link-maintainer-profile-git-trees-and-website.patch added to mm-unstable branch
Message-Id: <20230110224134.41FC2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS/DAMON: link maintainer profile, git trees, and website
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-damon-link-maintainer-profile-git-trees-and-website.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-damon-link-maintainer-profile-git-trees-and-website.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: MAINTAINERS/DAMON: link maintainer profile, git trees, and website
Date: Tue, 10 Jan 2023 19:03:58 +0000

Add links to below DAMON development related resource to DAMON section in
MAINTAINERS file.

- The basic policies and expectations of DAMON development,
- DAMON development trees, and
- DAMON introduction website.

Link: https://lkml.kernel.org/r/20230110190400.119388-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

--- a/MAINTAINERS~maintainers-damon-link-maintainer-profile-git-trees-and-website
+++ a/MAINTAINERS
@@ -5790,6 +5790,11 @@ M:	SeongJae Park <sj@kernel.org>
 L:	damon@lists.linux.dev
 L:	linux-mm@kvack.org
 S:	Maintained
+W:	https://damonitor.github.io
+P:	Documentation/mm/damon/maintainer-profile.rst
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git damon/next
 F:	Documentation/ABI/testing/sysfs-kernel-mm-damon
 F:	Documentation/admin-guide/mm/damon/
 F:	Documentation/mm/damon/
_

Patches currently in -mm which might be from sj@kernel.org are

include-linux-mm-fix-release_pages_arg-kernel-doc-comment.patch
mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix-fix-2.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch
mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch
mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator-fix.patch
maintainers-add-types-to-akpm-mm-git-trees-entries.patch
maintainers-memory-management-add-tools-vm-as-managed-files.patch
tools-vm-rename-tools-vm-to-tools-mm.patch
selftests-vm-rename-selftets-vm-to-selftests-mm.patch
selftests-vm-rename-selftets-vm-to-selftests-mm-fix.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections-fix.patch
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

