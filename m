From: akpm@linux-foundation.org
Subject: + fs-nls-add-apple-nls-fix.patch added to -mm tree
Date: Thu, 17 May 2012 15:47:36 -0700
Message-ID: <20120517224737.1F4BCA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52702 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030492Ab2EQWrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 May 2012 18:47:39 -0400
Received: by qcsp5 with SMTP id p5so306984qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 17 May 2012 15:47:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clemens@ladisch.de, hch@lst.de, hirofumi@mail.parknet.co.jp, phcoder@gmail.com, stern@rowland.harvard.edu, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs-nls-add-apple-nls-fix
has been added to the -mm tree.  Its filename is
     fs-nls-add-apple-nls-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-nls-add-apple-nls-fix

add unicode.org copyright and permission notices

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Vladimir Serbinenko <phcoder@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nls/nls_macceltic.c   |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_maccenteuro.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_maccroatian.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_maccyrillic.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_macgaelic.c   |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_macgreek.c    |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_maciceland.c  |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_macinuit.c    |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_macroman.c    |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_macromanian.c |   36 ++++++++++++++++++++++++++++++++++++
 fs/nls/nls_macturkish.c  |   36 ++++++++++++++++++++++++++++++++++++
 11 files changed, 396 insertions(+)

diff -puN fs/nls/nls_macceltic.c~fs-nls-add-apple-nls-fix fs/nls/nls_macceltic.c
--- a/fs/nls/nls_macceltic.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macceltic.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_maccenteuro.c~fs-nls-add-apple-nls-fix fs/nls/nls_maccenteuro.c
--- a/fs/nls/nls_maccenteuro.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_maccenteuro.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_maccroatian.c~fs-nls-add-apple-nls-fix fs/nls/nls_maccroatian.c
--- a/fs/nls/nls_maccroatian.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_maccroatian.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_maccyrillic.c~fs-nls-add-apple-nls-fix fs/nls/nls_maccyrillic.c
--- a/fs/nls/nls_maccyrillic.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_maccyrillic.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_macgaelic.c~fs-nls-add-apple-nls-fix fs/nls/nls_macgaelic.c
--- a/fs/nls/nls_macgaelic.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macgaelic.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_macgreek.c~fs-nls-add-apple-nls-fix fs/nls/nls_macgreek.c
--- a/fs/nls/nls_macgreek.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macgreek.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_maciceland.c~fs-nls-add-apple-nls-fix fs/nls/nls_maciceland.c
--- a/fs/nls/nls_maciceland.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_maciceland.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_macinuit.c~fs-nls-add-apple-nls-fix fs/nls/nls_macinuit.c
--- a/fs/nls/nls_macinuit.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macinuit.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_macroman.c~fs-nls-add-apple-nls-fix fs/nls/nls_macroman.c
--- a/fs/nls/nls_macroman.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macroman.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_macromanian.c~fs-nls-add-apple-nls-fix fs/nls/nls_macromanian.c
--- a/fs/nls/nls_macromanian.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macromanian.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff -puN fs/nls/nls_macturkish.c~fs-nls-add-apple-nls-fix fs/nls/nls_macturkish.c
--- a/fs/nls/nls_macturkish.c~fs-nls-add-apple-nls-fix
+++ a/fs/nls/nls_macturkish.c
@@ -7,6 +7,42 @@
  * The Unicode to charset table has only exact mappings.
  */
 
+/*
+ * COPYRIGHT AND PERMISSION NOTICE
+ *
+ * Copyright 1991-2012 Unicode, Inc.  All rights reserved.  Distributed under
+ * the Terms of Use in http://www.unicode.org/copyright.html.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of the Unicode data files and any associated documentation (the "Data
+ * Files") or Unicode software and any associated documentation (the
+ * "Software") to deal in the Data Files or Software without restriction,
+ * including without limitation the rights to use, copy, modify, merge,
+ * publish, distribute, and/or sell copies of the Data Files or Software, and
+ * to permit persons to whom the Data Files or Software are furnished to do
+ * so, provided that (a) the above copyright notice(s) and this permission
+ * notice appear with all copies of the Data Files or Software, (b) both the
+ * above copyright notice(s) and this permission notice appear in associated
+ * documentation, and (c) there is clear notice in each modified Data File or
+ * in the Software as well as in the documentation associated with the Data
+ * File(s) or Software that the data or software has been modified.
+ *
+ * THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
+ * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
+ * THIRD PARTY RIGHTS.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
+ * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
+ * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
+ * USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
+ * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
+ * PERFORMANCE OF THE DATA FILES OR SOFTWARE.
+ *
+ * Except as contained in this notice, the name of a copyright holder shall
+ * not be used in advertising or otherwise to promote the sale, use or other
+ * dealings in these Data Files or Software without prior written
+ * authorization of the copyright holder.
+ */
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
_
Subject: Subject: fs-nls-add-apple-nls-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation-fix.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support-fix.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy-fix.patch
mm-rename-is_mlocked_vma-to-mlocked_vma_newpage-fix.patch
mm-page_allocc-remove-pageblock_default_order.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch
mm-page_allocc-cleanups.patch
mm-optimize-put_mems_allowed-usage-fix.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
mm-memcg-print-statistics-from-live-counters-checkpatch-fixes.patch
memcg-always-free-struct-memcg-through-schedule_work-fix.patch
memcg-decrement-static-keys-at-real-destroy-time-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-v2-fix.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
drivers-video-backlight-apple_blc-include-header-for-exported-symbol-prototypes-fix.patch
backlight-add-lm3533-backlight-driver-fix.patch
backlight-add-lm3533-backlight-driver-fix-fix.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk-fix.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk-fix.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-generic_bl-use-pr_info-instead-of-printk-fix.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk-fix.patch
backlight-omap1-use-pr_info-instead-of-printk-fix.patch
backlight-progear-use-pr_err-instead-of-printk-fix.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix-fix.patch
leds-heartbeat-stop-on-shutdown-checkpatch-fixes.patch
drivers-leds-leds-pca955xc-fix-race-condition-while-setting-brightness-on-several-leds-fix.patch
lib-string_helpersc-make-arrays-static.patch
lib-bitmapc-fix-documentation-for-scnprintf-functions.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
kernel-cpuc-document-clear_tasks_mm_cpumask-fix.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support-checkpatch-fixes.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
fs-nls-add-apple-nls-fix.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

