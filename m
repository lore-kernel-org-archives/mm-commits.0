From: akpm@linux-foundation.org
Subject: [merged] readme-update-version-number-reference.patch removed
 from -mm tree
Date: Fri, 20 Mar 2015 12:06:06 -0700
Message-ID: <550c6f9e.fCC8HDQhTrILlf5M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbbCTTGH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 15:06:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: README: update version number reference
has been removed from the -mm tree.  Its filename was
     readme-update-version-number-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: README: update version number reference

When 4.0 is released, the README should reflect the new numbering.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 README |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN README~readme-update-version-number-reference README
--- a/README~readme-update-version-number-reference
+++ a/README
@@ -1,6 +1,6 @@
-        Linux kernel release 3.x <http://kernel.org/>
+        Linux kernel release 4.x <http://kernel.org/>
 
-These are the release notes for Linux version 3.  Read them carefully,
+These are the release notes for Linux version 4.  Read them carefully,
 as they tell you what this is all about, explain how to install the
 kernel, and what to do if something goes wrong. 
 
@@ -62,11 +62,11 @@ INSTALLING the kernel source:
    directory where you have permissions (eg. your home directory) and
    unpack it:
 
-     gzip -cd linux-3.X.tar.gz | tar xvf -
+     gzip -cd linux-4.X.tar.gz | tar xvf -
 
    or
 
-     bzip2 -dc linux-3.X.tar.bz2 | tar xvf -
+     bzip2 -dc linux-4.X.tar.bz2 | tar xvf -
 
    Replace "X" with the version number of the latest kernel.
 
@@ -75,16 +75,16 @@ INSTALLING the kernel source:
    files.  They should match the library, and not get messed up by
    whatever the kernel-du-jour happens to be.
 
- - You can also upgrade between 3.x releases by patching.  Patches are
+ - You can also upgrade between 4.x releases by patching.  Patches are
    distributed in the traditional gzip and the newer bzip2 format.  To
    install by patching, get all the newer patch files, enter the
-   top level directory of the kernel source (linux-3.X) and execute:
+   top level directory of the kernel source (linux-4.X) and execute:
 
-     gzip -cd ../patch-3.x.gz | patch -p1
+     gzip -cd ../patch-4.x.gz | patch -p1
 
    or
 
-     bzip2 -dc ../patch-3.x.bz2 | patch -p1
+     bzip2 -dc ../patch-4.x.bz2 | patch -p1
 
    Replace "x" for all versions bigger than the version "X" of your current
    source tree, _in_order_, and you should be ok.  You may want to remove
@@ -92,13 +92,13 @@ INSTALLING the kernel source:
    that there are no failed patches (some-file-name# or some-file-name.rej).
    If there are, either you or I have made a mistake.
 
-   Unlike patches for the 3.x kernels, patches for the 3.x.y kernels
+   Unlike patches for the 4.x kernels, patches for the 4.x.y kernels
    (also known as the -stable kernels) are not incremental but instead apply
-   directly to the base 3.x kernel.  For example, if your base kernel is 3.0
-   and you want to apply the 3.0.3 patch, you must not first apply the 3.0.1
-   and 3.0.2 patches. Similarly, if you are running kernel version 3.0.2 and
-   want to jump to 3.0.3, you must first reverse the 3.0.2 patch (that is,
-   patch -R) _before_ applying the 3.0.3 patch. You can read more on this in
+   directly to the base 4.x kernel.  For example, if your base kernel is 4.0
+   and you want to apply the 4.0.3 patch, you must not first apply the 4.0.1
+   and 4.0.2 patches. Similarly, if you are running kernel version 4.0.2 and
+   want to jump to 4.0.3, you must first reverse the 4.0.2 patch (that is,
+   patch -R) _before_ applying the 4.0.3 patch. You can read more on this in
    Documentation/applying-patches.txt
 
    Alternatively, the script patch-kernel can be used to automate this
@@ -120,7 +120,7 @@ INSTALLING the kernel source:
 
 SOFTWARE REQUIREMENTS
 
-   Compiling and running the 3.x kernels requires up-to-date
+   Compiling and running the 4.x kernels requires up-to-date
    versions of various software packages.  Consult
    Documentation/Changes for the minimum version numbers required
    and how to get updates for these packages.  Beware that using
@@ -137,12 +137,12 @@ BUILD directory for the kernel:
    place for the output files (including .config).
    Example:
 
-     kernel source code: /usr/src/linux-3.X
+     kernel source code: /usr/src/linux-4.X
      build directory:    /home/name/build/kernel
 
    To configure and build the kernel, use:
 
-     cd /usr/src/linux-3.X
+     cd /usr/src/linux-4.X
      make O=/home/name/build/kernel menuconfig
      make O=/home/name/build/kernel
      sudo make O=/home/name/build/kernel modules_install install
_

Patches currently in -mm which might be from jeffrey.t.kirsher@intel.com are

linux-next.patch

