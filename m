From: akpm@linux-foundation.org
Subject: [folded] fs-nls-add-apple-nls-fix.patch removed from -mm tree
Date: Thu, 31 May 2012 16:19:21 -0700
Message-ID: <20120531231921.45467A009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:57790 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599Ab2EaXTY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:19:24 -0400
Received: by wibhn6 with SMTP id hn6so2912wib.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:19:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clemens@ladisch.de, hch@lst.de, hirofumi@mail.parknet.co.jp, phcoder@gmail.com, stern@rowland.harvard.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-nls-add-apple-nls-fix
has been removed from the -mm tree.  Its filename was
     fs-nls-add-apple-nls-fix.patch

This patch was dropped because it was folded into fs-nls-add-apple-nls.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
isdn-add-missing-kern_cont.patch
kernel-irq-managec-use-the-pr_foo-infrastructure-to-prefix-printks.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format.patch
vsprintf-further-optimize-decimal-conversion.patch
proc-clean-up-proc-pid-environ-handling.patch
kernel-cpuc-document-clear_tasks_mm_cpumask.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
tools-selftests-add-mq_perf_tests.patch
ipc-mqueue-add-rbtree-node-caching-support.patch
pidns-make-killed-children-autoreap.patch
fs-nls-add-apple-nls.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch

