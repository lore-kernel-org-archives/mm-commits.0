Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFA6C4332B
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE5B264F32
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhBZBWi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:22:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhBZBVd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:21:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E027464F3A;
        Fri, 26 Feb 2021 01:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302461;
        bh=BaFi1w0L8j1HmLHMn+FMsVW8Xgt0SANiizAH2HejUGw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KHqcIrIdomEL+2IxRnaS2rqitKlOeODk9bUd93PfioOYM5OTwyTIkdIEWjF4UlK6+
         oUSRZOJtpc9cM0R5GeFjCeHGRmeUcHD14YYv6VgfttJ8La4S4S/We0xEb/AWjZ08Da
         wPTI48M6qWw5HA4ds/pMf8Zql+O/xoLs6DTe5Pp0=
Date:   Thu, 25 Feb 2021 17:21:00 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, ojeda@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 087/118] treewide: Miguel has moved
Message-ID: <20210226012100.hO2nducqJ%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Miguel Ojeda <ojeda@kernel.org>
Subject: treewide: Miguel has moved

Update contact info.

Link: https://lkml.kernel.org/r/20210206162524.GA11520@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                                            |    1=20
 CREDITS                                             |    9 ++-----
 Documentation/admin-guide/auxdisplay/cfag12864b.rst |    2 -
 Documentation/admin-guide/auxdisplay/ks0108.rst     |    2 -
 MAINTAINERS                                         |   12 +++++-----
 drivers/auxdisplay/cfag12864b.c                     |    4 +--
 drivers/auxdisplay/cfag12864bfb.c                   |    4 +--
 drivers/auxdisplay/ks0108.c                         |    4 +--
 include/linux/cfag12864b.h                          |    2 -
 include/linux/ks0108.h                              |    2 -
 samples/auxdisplay/cfag12864b-example.c             |    2 -
 11 files changed, 21 insertions(+), 23 deletions(-)

--- a/CREDITS~treewide-update-my-contact-info
+++ a/CREDITS
@@ -2841,14 +2841,11 @@ S: Subiaco, 6008
 S: Perth, Western Australia
 S: Australia
=20
-N: Miguel Ojeda Sandonis
-E: miguel.ojeda.sandonis@gmail.com
-W: http://miguelojeda.es
-W: http://jair.lab.fi.uva.es/~migojed/
+N: Miguel Ojeda
+E: ojeda@kernel.org
+W: https://ojeda.dev
 D: Author of the ks0108, cfag12864b and cfag12864bfb auxiliary display dri=
vers.
 D: Maintainer of the auxiliary display drivers tree (drivers/auxdisplay/*)
-S: C/ Mieses 20, 9-B
-S: Valladolid 47009
 S: Spain
=20
 N: Peter Oruba
--- a/Documentation/admin-guide/auxdisplay/cfag12864b.rst~treewide-update-m=
y-contact-info
+++ a/Documentation/admin-guide/auxdisplay/cfag12864b.rst
@@ -3,7 +3,7 @@ cfag12864b LCD Driver Documentation
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 :License:		GPLv2
-:Author & Maintainer:	Miguel Ojeda Sandonis
+:Author & Maintainer:	Miguel Ojeda <ojeda@kernel.org>
 :Date:			2006-10-27
=20
=20
--- a/Documentation/admin-guide/auxdisplay/ks0108.rst~treewide-update-my-co=
ntact-info
+++ a/Documentation/admin-guide/auxdisplay/ks0108.rst
@@ -3,7 +3,7 @@ ks0108 LCD Controller Driver Documentati
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 :License:		GPLv2
-:Author & Maintainer:	Miguel Ojeda Sandonis
+:Author & Maintainer:	Miguel Ojeda <ojeda@kernel.org>
 :Date:			2006-10-27
=20
=20
--- a/drivers/auxdisplay/cfag12864b.c~treewide-update-my-contact-info
+++ a/drivers/auxdisplay/cfag12864b.c
@@ -5,7 +5,7 @@
  * Description: cfag12864b LCD driver
  *     Depends: ks0108
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis
+ *      Author: Copyright (C) Miguel Ojeda <ojeda@kernel.org>
  *        Date: 2006-10-31
  */
=20
@@ -376,5 +376,5 @@ module_init(cfag12864b_init);
 module_exit(cfag12864b_exit);
=20
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>");
+MODULE_AUTHOR("Miguel Ojeda <ojeda@kernel.org>");
 MODULE_DESCRIPTION("cfag12864b LCD driver");
--- a/drivers/auxdisplay/cfag12864bfb.c~treewide-update-my-contact-info
+++ a/drivers/auxdisplay/cfag12864bfb.c
@@ -5,7 +5,7 @@
  * Description: cfag12864b LCD framebuffer driver
  *     Depends: cfag12864b
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis
+ *      Author: Copyright (C) Miguel Ojeda <ojeda@kernel.org>
  *        Date: 2006-10-31
  */
=20
@@ -171,5 +171,5 @@ module_init(cfag12864bfb_init);
 module_exit(cfag12864bfb_exit);
=20
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>");
+MODULE_AUTHOR("Miguel Ojeda <ojeda@kernel.org>");
 MODULE_DESCRIPTION("cfag12864b LCD framebuffer driver");
--- a/drivers/auxdisplay/ks0108.c~treewide-update-my-contact-info
+++ a/drivers/auxdisplay/ks0108.c
@@ -5,7 +5,7 @@
  * Description: ks0108 LCD Controller driver
  *     Depends: parport
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis
+ *      Author: Copyright (C) Miguel Ojeda <ojeda@kernel.org>
  *        Date: 2006-10-31
  */
=20
@@ -182,6 +182,6 @@ module_init(ks0108_init);
 module_exit(ks0108_exit);
=20
 MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>");
+MODULE_AUTHOR("Miguel Ojeda <ojeda@kernel.org>");
 MODULE_DESCRIPTION("ks0108 LCD Controller driver");
=20
--- a/include/linux/cfag12864b.h~treewide-update-my-contact-info
+++ a/include/linux/cfag12864b.h
@@ -4,7 +4,7 @@
  *     Version: 0.1.0
  * Description: cfag12864b LCD driver header
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis
+ *      Author: Copyright (C) Miguel Ojeda <ojeda@kernel.org>
  *        Date: 2006-10-12
  */
=20
--- a/include/linux/ks0108.h~treewide-update-my-contact-info
+++ a/include/linux/ks0108.h
@@ -4,7 +4,7 @@
  *     Version: 0.1.0
  * Description: ks0108 LCD Controller driver header
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis
+ *      Author: Copyright (C) Miguel Ojeda <ojeda@kernel.org>
  *        Date: 2006-10-31
  */
=20
--- a/.mailmap~treewide-update-my-contact-info
+++ a/.mailmap
@@ -237,6 +237,7 @@ Maxime Ripard <mripard@kernel.org> <maxi
 Mayuresh Janorkar <mayur@ti.com>
 Michael Buesch <m@bues.ch>
 Michel D=C3=A4nzer <michel@tungstengraphics.com>
+Miguel Ojeda <ojeda@kernel.org> <miguel.ojeda.sandonis@gmail.com>
 Mike Rapoport <rppt@kernel.org> <mike@compulab.co.il>
 Mike Rapoport <rppt@kernel.org> <mike.rapoport@gmail.com>
 Mike Rapoport <rppt@kernel.org> <rppt@linux.ibm.com>
--- a/MAINTAINERS~treewide-update-my-contact-info
+++ a/MAINTAINERS
@@ -2982,7 +2982,7 @@ F:	include/uapi/linux/audit.h
 F:	kernel/audit*
=20
 AUXILIARY DISPLAY DRIVERS
-M:	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
+M:	Miguel Ojeda <ojeda@kernel.org>
 S:	Maintained
 F:	drivers/auxdisplay/
 F:	include/linux/cfag12864b.h
@@ -4128,13 +4128,13 @@ F:	scripts/extract-cert.c
 F:	scripts/sign-file.c
=20
 CFAG12864B LCD DRIVER
-M:	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
+M:	Miguel Ojeda <ojeda@kernel.org>
 S:	Maintained
 F:	drivers/auxdisplay/cfag12864b.c
 F:	include/linux/cfag12864b.h
=20
 CFAG12864BFB LCD FRAMEBUFFER DRIVER
-M:	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
+M:	Miguel Ojeda <ojeda@kernel.org>
 S:	Maintained
 F:	drivers/auxdisplay/cfag12864bfb.c
 F:	include/linux/cfag12864b.h
@@ -4304,7 +4304,7 @@ S:	Supported
 F:	drivers/infiniband/hw/usnic/
=20
 CLANG-FORMAT FILE
-M:	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
+M:	Miguel Ojeda <ojeda@kernel.org>
 S:	Maintained
 F:	.clang-format
=20
@@ -4444,7 +4444,7 @@ S:	Maintained
 F:	drivers/platform/x86/compal-laptop.c
=20
 COMPILER ATTRIBUTES
-M:	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
+M:	Miguel Ojeda <ojeda@kernel.org>
 S:	Maintained
 F:	include/linux/compiler_attributes.h
=20
@@ -9939,7 +9939,7 @@ F:	include/linux/kprobes.h
 F:	kernel/kprobes.c
=20
 KS0108 LCD CONTROLLER DRIVER
-M:	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>
+M:	Miguel Ojeda <ojeda@kernel.org>
 S:	Maintained
 F:	Documentation/admin-guide/auxdisplay/ks0108.rst
 F:	drivers/auxdisplay/ks0108.c
--- a/samples/auxdisplay/cfag12864b-example.c~treewide-update-my-contact-in=
fo
+++ a/samples/auxdisplay/cfag12864b-example.c
@@ -4,7 +4,7 @@
  *     Version: 0.1.0
  * Description: cfag12864b LCD userspace example program
  *
- *      Author: Copyright (C) Miguel Ojeda Sandonis
+ *      Author: Copyright (C) Miguel Ojeda <ojeda@kernel.org>
  *        Date: 2006-10-31
  */
=20
_
