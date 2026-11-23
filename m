Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415116;
	b=jGvoFqtqx4t9m9Rg0Z95x0XE8roLpovrbL5jYPqtlcEm/i1Id8+Vj2cBsVWo+CPaMLEt
	 kHX0bNABJXecxJUVy8PQrMh3rdDr9Ou8tVnU/HrAGEgXGj550En99o6Yj9JxOQgH3c5Tf
	 ES/v/uGxCWsd7uCNqTNBW+Tu1Qe62R4qsExlKnyo10H9H9GPdfsE4iYMjb3QiZebyQMKY
	 OPV+nVUEWfi0fpcTpSJEY6ZBOWJEjGXa0pAW9QTAyvORleXrCHmvJSg9rfhJQP8MfYnpD
	 nRRXk20tzg2KJTK0kUMNc5QPiSbfFENuG/ifHG5JkDGrGcMDy383OgtiVnGlH4KY03A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415116;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2gGBj7VCBYoyTOqjoI22Fg3nekgK8FbObEEnMEW0274=;
	b=Xqty0AxuXwuV0gOCJ5emhzRBNv3ZiX+LowAo+m5HJRuGwYxaxJqtfZKuZJwjAxnWJvh/
	 pODC5uOfGJR9J8MXely+KZGppa9t9mPbR/Jn3MMBrUNyaSH4l5itSzr0ulpfiLJeyaGuo
	 dPl+3fsspYEasp3Sg2JiTW4hKT9leUF3JKYCj2toA3CrU3fTayAoEj3uynwYMSKa5/h/W
	 RkIUgfdX/+J7Zby8nyLbPyU/ehDD7yFYeSUm0j/8hFlMM8HcDfXNIcUbkf13BqTHnlXiT
	 1jAXloP73PW2peo58Tjg/T8rzXkzd+HMWFJOOP0SpxIZJnV+VgfvBVBwmcc94j8P8pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Hfj0M/KK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7AF606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 06:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Hfj0M/KK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3664C1F000C6;
	Mon, 23 Nov 2026 06:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415116;
	bh=2gGBj7VCBYoyTOqjoI22Fg3nekgK8FbObEEnMEW0274=;
	h=Date:To:From:Subject;
	b=Hfj0M/KK6GlCJi2LYDKxJJP1PWquBmWK7JHtGPbCDr2ozLoHARo+QZw3/g4xbRNh5
	 kBNiPm8SFfXUyoj0ctfZRXUliuPosxnMUGC+VaLADpcJk0kHAqm4KwvHaJ8iunkJP5
	 qkhepoGnIl2wx92ap/BIgwjIt8j0cyGQBQtHL/Qw=
Date: Sun, 22 Nov 2026 22:25:15 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-page_exth-to-memory-management-page-allocator.patch removed from -mm tree
Message-Id: <20261123062516.3664C1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: add page_ext.h to MEMORY MANAGEMENT - PAGE ALLOCATOR
has been removed from the -mm tree.  Its filename was
     maintainers-add-page_exth-to-memory-management-page-allocator.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: add page_ext.h to MEMORY MANAGEMENT - PAGE ALLOCATOR
Date: Tue Nov 17 11:05:44 AM PST 2026

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-page_exth-to-memory-management-page-allocator
+++ a/MAINTAINERS
@@ -17779,6 +17779,7 @@ F:	include/linux/compaction.h
 F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
 F:	include/linux/pageblock-flags.h
+F:	include/linux/page_ext.h
 F:	include/trace/events/compaction.h
 F:	include/trace/events/page_isolation.h
 F:	include/trace/events/page_ref.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch
mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix.patch
lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch
lib-test_hmm-invalidate-all-mirrors-on-device-private-migration-fix.patch
mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch
selinux-recheck-backing-file-permissions-on-remap_file_pages.patch
mm-madvise-notify-userfaultfd-when-installing-guard-regions.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-2.patch
fuse-let-memory-failure-remove-poisoned-page-cache-folios.patch
nilfs2-report-mapping-errors-from-fsync.patch
ipc-msg-serialize-receive-permission-checks-with-ipc_set.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
jfs-validate-xattr-entry-bounds-before-replacing-an-attribute.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

