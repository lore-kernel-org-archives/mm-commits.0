From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 4 Aug 2016 15:31:33 -0700
Message-ID: <20160804153133.4b1758e01042a6353b7adf8a@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759232AbcHDWbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 18:31:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


A few late-breaking fixes.

7 fixes, based on c1ece76719205690f4b448460d9b85c130e8021b:

Subject: mm: disable CONFIG_MEMORY_HOTPLUG when KASAN is enabled
Subject: mm/memblock: fix a typo in a comment
Subject: mm: initialise per_cpu_nodestats for all online pgdats at boot
Subject: powerpc/fsl_rio: fix a missing error code
Subject: slub: drop bogus inline for fixup_red_left()
Subject: MAINTAINERS: update cgroup's document path
Subject: mm/memblock.c: fix NULL dereference error

