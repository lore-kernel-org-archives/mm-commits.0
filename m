From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 14 Jul 2017 14:46:54 -0700
Message-ID: <20170714144654.cf72aa6430dfadc32ecdb617@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdGNVqz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jul 2017 17:46:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- a few leftovers

- fault-injector rework

- add a module loader test driver

13 patches, based on b86faee6d111294fa95a2e89b5f771b2da3c9782:

Subject: mm: fix overflow check in expand_upwards()
Subject: lib/atomic64_test.c: add a test that atomic64_inc_not_zero() returns an int
Subject: MAINTAINERS: move the befs tree to kernel.org
Subject: kernel/watchdog.c: use better pr_fmt prefix
Subject: fault-inject: automatically detect the number base for fail-nth write interface
Subject: fault-inject: parse as natural 1-based value for fail-nth write interface
Subject: fault-inject: make fail-nth read/write interface symmetric
Subject: fault-inject: simplify access check for fail-nth
Subject: fault-inject: add /proc/<pid>/fail-nth
Subject: xtensa: use generic fb.h
Subject: MAINTAINERS: give kmod some maintainer love
Subject: kmod: add test driver to stress test the module loader
Subject: kmod: throttle kmod thread limit

