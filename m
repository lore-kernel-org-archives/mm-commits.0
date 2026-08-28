Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A4629E10B
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 17:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787937725; cv=none; b=IgOaUWry7R+zeFR5cyyJ3H4ixRDbj87bcUzQHq9uw3Wt/FxTjVH6uzpeeYkU2SnDuIr5eVeMZ9IlPzvNIu52mwAHnqw0QbDr4GcOTu/2phCYfmEIjRV/UBre/2/hS27dF3P9uZAS/gbyaBesPJCwiMWDQGrx0Wt9najkCf/w3Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787937725; c=relaxed/simple;
	bh=ncIWG5KT3bDmKnVvCSmPpWGwlDfQvEb2tOJOcyCyvq0=;
	h=Date:To:From:Subject:Message-Id; b=kZUV+dei7MbsRCohUmwvqP6uG0XuyQ0dwVnEynK4fQX2DeDWbCFlPLMK3jFkKv4AdZPxlIopdvs26UHGppeyhADH4F/mtHk+WlGD4IbH6p+QF0N9Gj0vacWSWCeC/bG1s7YqoqG+Dnr83syCHturIcFl5Gco0szZVNcLfO9ZFUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lDIUwK7N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lDIUwK7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194261F00A3D;
	Fri, 28 Aug 2026 17:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787937723;
	bh=VxaiHF/cEcI0eRlLzSRsmkwN/n21IRVMuxDwO7wJk5k=;
	h=Date:To:From:Subject;
	b=lDIUwK7N+CLSoQ+X/6LGGqbSSI4ON/rX+EcfZxTj5OcGZB+I3ptK0iAsoTpyD+zJj
	 99/j4XdYJ89RwhquSNCI0e1D2nyBgbX5u7ESEy+TKxpcVv2HYvwFzcnTaxhkqwPnLn
	 /LC0kzjiQxBDtFbZyei7mCkEPXBhDCBOrmrPnT84=
Date: Fri, 28 Aug 2026 10:22:02 -0700
To: mm-commits@vger.kernel.org,coiby.xu@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-map-coiby-xus-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20260828172203.194261F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: map Coiby Xu's address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-map-coiby-xus-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-map-coiby-xus-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Coiby Xu <coiby.xu@gmail.com>
Subject: mailmap: map Coiby Xu's address
Date: Fri, 28 Aug 2026 16:41:06 +0800

Point to my gmail address as I've left Red Hat.

Link: https://lore.kernel.org/20260828084106.1494733-1-coiby.xu@gmail.com
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-map-coiby-xus-address
+++ a/.mailmap
@@ -221,6 +221,7 @@ Chuck Lever <cel@kernel.org> <chuck.leve
 Chuck Lever <cel@kernel.org> <cel@netapp.com>
 Chuck Lever <cel@kernel.org> <cel@citi.umich.edu>
 Claudiu Beznea <claudiu.beznea@tuxon.dev> <claudiu.beznea@microchip.com>
+Coiby Xu <coiby.xu@gmail.com> <coxu@redhat.com>
 Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
 Corey Minyard <minyard@acm.org>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
_

Patches currently in -mm which might be from coiby.xu@gmail.com are

mailmap-map-coiby-xus-address.patch

