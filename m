Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6660B23BF9F
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 20:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861311; cv=none; b=gOydjv+F+TsszjmjZVseBBLU8C0YN7XQ3NYJ4J019aTjMZN3/7IJSwCU0vaVxbU+mWwyx/6VygR7oXhXrzcpRdBCWq2oC+83vBXJZgYXhUr4zM6znpQ3MZI79sCa5RIHVNeIQ6eOSiK1h++yRzRxV53gwhVG92yYp5p3y0UvbHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861311; c=relaxed/simple;
	bh=42P1tuU5WoMPCYsBQGHXrvn10E//Z7qqu5L74eaQcdk=;
	h=Date:To:From:Subject:Message-Id; b=uT3p2yvqDH0wbOJHF+I1mGZ+4jgZzXkoqhkZ9sU/SJ8F/gBEwfx1nt8gWFXN3pWV+vnGObs1wbeQ1uDkjQIyznDyo3ZaoyXeIrfVk/oQ5wRjUpQGZ56TIfhwwfLjwXQMMRx9HPtGF+Yhki6hkJ2IY1XquNmTIyoZW6ceUQae6YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JBfg6iCX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JBfg6iCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3FD1F000E9;
	Thu, 27 Aug 2026 20:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787861310;
	bh=NcorbtcYmZlr4dZeNcwpoRDzk4BBRLhRThthC8TnQ2o=;
	h=Date:To:From:Subject;
	b=JBfg6iCXim+r5Usam6p1V5U27yJXxILZIqhxC/yUpf4+pEyZnXC59xfGte2sUIYyq
	 QqYT+GJzdsCy0hWlRTngf7Sxicfs4wG/3rKJvczfTwTiy1jZwB1kOVctvg7E90wXKO
	 MLexvpAifQ8e49dm9m6ZlstYLJVK3ubCs5xMV+Sw=
Date: Thu, 27 Aug 2026 13:08:29 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-lance-yang-as-a-hung-task-detector-co-maintainer.patch removed from -mm tree
Message-Id: <20260827200830.3D3FD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Lance Yang as a hung task detector co-maintainer
has been removed from the -mm tree.  Its filename was
     maintainers-add-lance-yang-as-a-hung-task-detector-co-maintainer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: MAINTAINERS: add Lance Yang as a hung task detector co-maintainer
Date: Thu, 20 Aug 2026 09:45:35 +0800

I've been a hung_task reviewer for over a year now and plan to stay
involved.

Take on more responsibility for hung_task as a co-maintainer.

Link: https://lore.kernel.org/20260820014535.79105-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Petr Mladek <pmladek@suse.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-lance-yang-as-a-hung-task-detector-co-maintainer
+++ a/MAINTAINERS
@@ -12224,7 +12224,7 @@ F:	drivers/tty/hvc/
 
 HUNG TASK DETECTOR
 M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Lance Yang <lance.yang@linux.dev>
+M:	Lance Yang <lance.yang@linux.dev>
 R:	Masami Hiramatsu <mhiramat@kernel.org>
 R:	Petr Mladek <pmladek@suse.com>
 L:	linux-kernel@vger.kernel.org
_

Patches currently in -mm which might be from lance.yang@linux.dev are


