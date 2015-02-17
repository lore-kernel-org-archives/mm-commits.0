From: akpm@linux-foundation.org
Subject: [folded-merged] samples-seccomp-improve-label-helper-fix.patch
 removed from -mm tree
Date: Tue, 17 Feb 2015 13:40:09 -0800
Message-ID: <54e3b539.+iALugt/lJ06/rcl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbbBQVkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 16:40:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: samples-seccomp-improve-label-helper-fix
has been removed from the -mm tree.  Its filename was
     samples-seccomp-improve-label-helper-fix.patch

This patch was dropped because it was folded into samples-seccomp-improve-label-helper.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: samples-seccomp-improve-label-helper-fix

coding-style fixlet

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/seccomp/bpf-helper.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN samples/seccomp/bpf-helper.c~samples-seccomp-improve-label-helper-fix samples/seccomp/bpf-helper.c
--- a/samples/seccomp/bpf-helper.c~samples-seccomp-improve-label-helper-fix
+++ a/samples/seccomp/bpf-helper.c
@@ -64,6 +64,7 @@ __u32 seccomp_bpf_label(struct bpf_label
 {
 	struct __bpf_label *begin = labels->labels, *end;
 	int id;
+
 	if (labels->count == BPF_LABELS_MAX) {
 		fprintf(stderr, "Too many labels\n");
 		exit(1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-befs-linuxvfsc-remove-unnecessary-casting.patch
samples-seccomp-improve-label-helper.patch

