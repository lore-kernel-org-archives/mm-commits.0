Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7DF4E4315
	for <mm-commits@vger.kernel.org>; Tue,  6 Oct 2026 23:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330297; cv=none; b=Ucl3lfibojrYqxO56rNIv2d19SDYfbopazpZvGPomuORI/34IqI+w8uMSrZOPyrIB4cUAtYDHxavokXhAjbYVNhV22KOjrYMCbxnDV9XwM3tiM7VvdhoyNoCol5+oCuyJx3xgGZc6Q0uRd4HHt0YQMhHqoujfx91D6/e59KXOw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330297; c=relaxed/simple;
	bh=42rOyNBW21QPpXFO+gGb4oZzk32WKUnDFkKr+GLrz8E=;
	h=Date:To:From:Subject:Message-Id; b=c1XBqtotgYJzyyjFMQFI/xhDp/Ba248QuXob6F0+x1QcY7RfotQcALJL9cN3PgbG0lAHgnlYvmNUsCz4CjhIvnOjc0R0jwbjAeod/hoBhJWh3W8+aWmsuqS3snZ4EtHoCol6qyFRA34dx/sef0YMJn1lk38pTjqlS5P6yUQOqq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OodPt7Qu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OodPt7Qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A841F0089B;
	Tue,  6 Oct 2026 23:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791330295;
	bh=TcD9GuhlHbx27OfIJZs244csrQ14X2/0rY7UlDXpNfY=;
	h=Date:To:From:Subject;
	b=OodPt7QugHRa59vUweJmtoGbDlDAsGLa00oiuI0Oh9auyuQEhbMdsZ2CYqgQbC4/z
	 AMR+0KhKbhOXSDflg+wv4r/bfrv90lGQ1qK4PMbcigXYdBf3PCyxdo7wlBFJ7iaDAV
	 4PDdDLgBnf4R+cLcWOTaVxHdUZeZX76GNur5p1vE=
Date: Tue, 06 Oct 2026 16:44:54 -0700
To: mm-commits@vger.kernel.org,shawn.lin@rock-chips.com,martink@posteo.de,kuba@kernel.org,cel@kernel.org,alex@sverdlin.org,andyshrk@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-entry-for-andy-yan.patch removed from -mm tree
Message-Id: <20261006234455.35A841F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update entry for Andy Yan
has been removed from the -mm tree.  Its filename was
     mailmap-update-entry-for-andy-yan.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Yan <andyshrk@163.com>
Subject: mailmap: update entry for Andy Yan
Date: Thu, 24 Sep 2026 18:50:33 +0800

I will use andyshrk@163.com for future review and discussion.

Link: https://lore.kernel.org/20260924105052.768760-1-andyshrk@163.com
Signed-off-by: Andy Yan <andyshrk@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Alexander Sverdlin <alex@sverdlin.org>
Cc: Chuck Lever <cel@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-entry-for-andy-yan
+++ a/.mailmap
@@ -101,6 +101,7 @@ Andy Chiu <andybnac@gmail.com> <andy.chi
 Andy Chiu <andybnac@gmail.com> <taochiu@synology.com>
 Andy Shevchenko <andy@kernel.org> <andy@smile.org.ua>
 Andy Shevchenko <andy@kernel.org> <ext-andriy.shevchenko@nokia.com>
+Andy Yan <andyshrk@163.com> <andy.yan@rock-chips.com>
 Anilkumar Kolli <quic_akolli@quicinc.com> <akolli@codeaurora.org>
 Anirudh Ghayal <quic_aghayal@quicinc.com> <aghayal@codeaurora.org>
 Antoine Tenart <atenart@kernel.org> <antoine.tenart@bootlin.com>
_

Patches currently in -mm which might be from andyshrk@163.com are


