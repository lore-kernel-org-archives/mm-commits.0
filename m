From: akpm@linux-foundation.org
Subject: [folded-merged]
 docs-admin-guide-document-the-kernelmodprobe-sysctl-v5.patch removed from
 -mm tree
Date: Fri, 10 Apr 2020 14:13:32 -0700
Message-ID: <20200410211332.0fpezLbib%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgDJVNf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:13:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, ebiggers@google.com, gregkh@linuxfoundation.org, jeffv@google.com, jeyu@kernel.org, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, neilb@suse.com


The patch titled
     Subject: docs-admin-guide-document-the-kernelmodprobe-sysctl-v5
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-document-the-kernelmodprobe-sysctl-v5.patch

This patch was dropped because it was folded into docs-admin-guide-document-the-kernelmodprobe-sysctl.patch

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: docs-admin-guide-document-the-kernelmodprobe-sysctl-v5

Link: http://lkml.kernel.org/r/20200318230515.171692-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~docs-admin-guide-document-the-kernelmodprobe-sysctl-v5
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -452,8 +452,8 @@ modprobe:
 The path to the usermode helper for autoloading kernel modules, by
 default "/sbin/modprobe".  This binary is executed when the kernel
 requests a module.  For example, if userspace passes an unknown
-filesystem type "foo" to mount(), then the kernel will automatically
-request the module "fs-foo.ko" by executing this usermode helper.
+filesystem type to mount(), then the kernel will automatically request
+the corresponding filesystem module by executing this usermode helper.
 This usermode helper should insert the needed module into the kernel.
 
 This sysctl only affects module autoloading.  It has no effect on the
_

Patches currently in -mm which might be from ebiggers@google.com are

kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch
fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch
docs-admin-guide-document-the-kernelmodprobe-sysctl.patch
selftests-kmod-fix-handling-test-numbers-above-9.patch
selftests-kmod-test-disabling-module-autoloading.patch
