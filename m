From: akpm@linux-foundation.org
Subject: [folded-dropped] coredump-add-support-for-%d=__get_dumpable-in-core-name-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 17:02:36 -0700
Message-ID: <20121005000236.72C8F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:55107 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab2JEACh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 20:02:37 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so130038vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 17:02:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject:  coredump-add-support-for-%d=__get_dumpable-in-core-name-fix
has been removed from the -mm tree.  Its filename was
     coredump-add-support-for-%d=__get_dumpable-in-core-name-fix.patch

This patch was dropped because it was folded into coredump-add-support-for-%d=__get_dumpable-in-core-name.patch

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject:  coredump-add-support-for-%d=__get_dumpable-in-core-name-fix

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~coredump-add-support-for-%d=__get_dumpable-in-core-name-fix Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~coredump-add-support-for-%d=__get_dumpable-in-core-name-fix
+++ a/Documentation/sysctl/kernel.txt
@@ -181,6 +181,8 @@ core_pattern is used to specify a core d
 	%p	pid
 	%u	uid
 	%g	gid
+	%d	dump mode, matches PR_SET_DUMPABLE and
+		/proc/sys/fs/suid_dumpable
 	%s	signal number
 	%t	UNIX time of dump
 	%h	hostname
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
coredump-add-support-for-%d=__get_dumpable-in-core-name.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr.patch
compat-move-compat_siginfo_t-definition-to-asm-compath.patch
coredump-add-a-new-elf-note-with-siginfo-of-the-signal.patch
coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files.patch

