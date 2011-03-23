From: akpm@linux-foundation.org
Subject: [folded] userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:23:29 -0700
Message-ID: <201103232323.p2NNNTJC004542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932972Ab1CWXYP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:24:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com, serge@hallyn.com, mm-commits@vger.kernel.org


The patch titled
     userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix
has been removed from the -mm tree.  Its filename was
     userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix.patch

This patch was dropped because it was folded into userns-security-make-capabilities-relative-to-the-user-namespace.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

export current_user_ns() for ecryptfs.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cred.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/cred.c~userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix kernel/cred.c
--- a/kernel/cred.c~userns-security-make-capabilities-relative-to-the-user-namespace-fix-fix
+++ a/kernel/cred.c
@@ -745,6 +745,7 @@ struct user_namespace *current_user_ns(v
 {
 	return _current_user_ns();
 }
+EXPORT_SYMBOL(current_user_ns);
 
 #ifdef CONFIG_DEBUG_CREDENTIALS
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-adfs-adfsh-fix-unsigned-comparison.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch

