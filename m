From: akpm@linux-foundation.org
Subject: +
 docs-admin-guide-document-the-kernelmodprobe-sysctl-v5.patch added to -mm
 tree
Date: Sat, 28 Mar 2020 16:10:56 -0700
Message-ID: <20200328231056.il0roT5O_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727175AbgC1XK7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 28 Mar 2020 19:10:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, ebiggers@google.com, gregkh@linuxfoundation.org, jeffv@google.com, jeyu@kernel.org, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, neilb@suse.com


The patch titled
     Subject: docs-admin-guide-document-the-kernelmodprobe-sysctl-v5
has been added to the -mm tree.  Its filename is
     docs-admin-guide-document-the-kernelmodprobe-sysctl-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/docs-admin-guide-document-the-kernelmodprobe-sysctl-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/docs-admin-guide-document-the-kernelmodprobe-sysctl-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
docs-admin-guide-document-the-kernelmodprobe-sysctl-v5.patch
selftests-kmod-fix-handling-test-numbers-above-9.patch
selftests-kmod-test-disabling-module-autoloading.patch
