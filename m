From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-clarify-kmod-is-just-a-kernel-module-loader.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:43:40 -0700
Message-ID: <20170911194340.7RFpI1MYK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50652 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdIKTnn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:43:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, dan.carpenter@oracle.com, danielmentz@google.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, gregkh@linuxfoundation.org, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, linux@roeck-us.net, matt.redfearn@imgtec.com, mbenes@suse.cz, mcgrof@kernel.org, mm-commits@vger.kernel.org, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au


The patch titled
     Subject: MAINTAINERS: clarify kmod is just a kernel module loader
has been removed from the -mm tree.  Its filename was
     maintainers-clarify-kmod-is-just-a-kernel-module-loader.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: MAINTAINERS: clarify kmod is just a kernel module loader

This should make it clearer what the kmod code is now that
the umh code is split out separately.

Link: http://lkml.kernel.org/r/20170810180618.22457-3-mcgrof@kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Redfearn <matt.redfearn@imgtec.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Daniel Mentz <danielmentz@google.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-clarify-kmod-is-just-a-kernel-module-loader MAINTAINERS
--- a/MAINTAINERS~maintainers-clarify-kmod-is-just-a-kernel-module-loader
+++ a/MAINTAINERS
@@ -7623,7 +7623,7 @@ F:	include/linux/kmemleak.h
 F:	mm/kmemleak.c
 F:	mm/kmemleak-test.c
 
-KMOD MODULE USERMODE HELPER
+KMOD KERNEL MODULE LOADER - USERMODE HELPER
 M:	"Luis R. Rodriguez" <mcgrof@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from mcgrof@kernel.org are


