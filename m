Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95C32BEC2B
	for <mm-commits@vger.kernel.org>; Fri, 17 Apr 2026 06:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776405652; cv=none; b=CK+ptSA1zANzY8rueVw+/UgOEKtHJNRpYHXtZxD6VxKJiguDhapEnY0/Hcc4TU9Pi7Sk9XfYzfHxLMzbOTiaWSaJ8oY1SUwr9qvRF223w0QQxvMTRBcXSu24yWxVPTGGV6CJDoi06G0h7Bv/W3ab0ZvwAI9K+9Xwp1OFS+5UHns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776405652; c=relaxed/simple;
	bh=vJMLecZK1QMTEygEInu9JKRkDW190XL+bW0PjTozBXo=;
	h=Date:To:From:Subject:Message-Id; b=Ssnx+LyV35z3WbpdsLEcQ73rlkHJ7yt6BfG0tUJIRGFr2dxD+DdA9mS37iVFS2cIMnHKmroA70WUMG8R+recWsXz1v5cMIJzxIdYMX03chcDf6lh2NDDu0OQjegKJCGdfagnJhhTQuaF0FU09nEd2IgCGsy+2L6dxMsle4SYvlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CESUAHj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CESUAHj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD40C19425;
	Fri, 17 Apr 2026 06:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776405652;
	bh=vJMLecZK1QMTEygEInu9JKRkDW190XL+bW0PjTozBXo=;
	h=Date:To:From:Subject:From;
	b=CESUAHj/SBi30nHSWCMKvTzUhN+qiG+L0P/IM8K9AlL72xi2cGi0GWTzVbYUPh9Sl
	 ngs0owKzJdkHl2e36H8/CIkfduh1I4CILVQeLT6XIjdYL/RPu/WSXUd+1TOLPfiAke
	 mv0480VJd9BnU3+BlK9Inf4pqyRK4pJEcqreSnq0=
Date: Thu, 16 Apr 2026 23:00:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maintainers-add-page-cache-reviewer-fix.patch removed from -mm tree
Message-Id: <20260417060051.BDD40C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maintainers-add-page-cache-reviewer-fix
has been removed from the -mm tree.  Its filename was
     maintainers-add-page-cache-reviewer-fix.patch

This patch was dropped because it was folded into maintainers-add-page-cache-reviewer.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maintainers-add-page-cache-reviewer-fix
Date: Wed Apr 15 10:47:13 PM PDT 2026

add linux-mm@kvack.org

Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-page-cache-reviewer-fix
+++ a/MAINTAINERS
@@ -19966,6 +19966,7 @@ PAGE CACHE
 M:	Matthew Wilcox (Oracle) <willy@infradead.org>
 R:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
+L:	linux-mm@kvack.org
 S:	Supported
 T:	git git://git.infradead.org/users/willy/pagecache.git
 F:	Documentation/filesystems/locking.rst
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-page-cache-reviewer.patch

